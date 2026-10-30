//
//  RakutenAPIService.swift
//  YomimiApp
//
//  Created by 奈宮史典 on 2026/10/21.
//

import Foundation

// 1 RakutenAPIService側のみから受け取る型
/* JSONのプロトコルについては3つ
 Encodable: Swift の型 → JSON(書き出す方向)。
 Decodable: JSON → Swift の型(読み込む方向)。「デコード」は、データを読み解いて自分の型に変えることです。
 Codable: この2つをまとめた名前です。「読むこともできるし、書くこともできる」という意味になります。
*/
private struct RakutenAPISummary: Decodable {
    let isbn: String?
    let title: String?
    let author: String?
    let publisherName: String?
    let salesDate: String? // 出版日：売られた日を一旦出版日にする（例：「2026年06月22日頃」として連携される）
    let largeImageUrl: String? // 書影URL
    let itemPrice: Int? // 価格（のちのち使う可能性も踏まえ・・・）
    let itemCaption: String? // 書籍の説明（ここは使う時に要注意。他の書籍も検索してみて判断すること）
}

private struct RakutenAPIImte: Decodable {
    let Item: RakutenAPISummary?
}

//private struct RakutenAPIResponse: Decodable {
//    let Items: [RakutenAPIImte]
//}
private struct RakutenAPIResponse: Decodable {
    let Items: [RakutenAPIImte]
}

struct RakutenAPIService: BookAPIService {
    
    // 合言葉の読み出し
    private let XAppToken = Bundle.main.object(forInfoDictionaryKey: "AppToken") as? String
    
    func fetchBookInfo(isbn: String) async throws -> BookAPISummary { // async throws：非同期でエラーが返ってくるかも・・・を許容する
                
        
        /* ====== HTTPS通信 =====
            # 概要
                楽天APIを直接叩けないのでハブを経由してAPIを叩きに行っている
                そのハブをHTTPS通信でリクエストを送る
            # 設定値
            ・メソッド：GET
                情報を取りに行くので。データを作成したい場合はPOST
            ・ヘッダー：X-App-Token + 合言葉
         
            # 補足
            ・ヘッダーのaddValueかsetValueの使い分けについて
                addにしなかったのは、間違って同じフィールドのaddValueを2回行わないため。行うと文字列が連結されてしまう。
        */
        // リクエスト前準備
        guard let url = URL(string: "https://yomimi.shidiannaigong.workers.dev/book?isbn=\(isbn)") else {
        #if DEBUG
            print("🌐 [RakutenAPIService] urlのインスタン化に失敗")
            #endif
            throw BookAPIError.invalidURL
        }
        var request = URLRequest(url: url, timeoutInterval: 60) // タイムアウトはデフォルト60s
        request.httpMethod = "GET"
        request.setValue(XAppToken, forHTTPHeaderField: "X-App-Token")
        
        // リクエスト
        #if DEBUG
        print("🌐 [RakutenAPIService] リクエスト開始: \(url)")
        print("🌐 [RakutenAPIService] 合言葉の取得確認: \(XAppToken?.isEmpty)") // Optional(false)で合言葉を正常に取得
        #endif
        
        let data: Data
        let response: URLResponse
        do {
            (data, response) = try await URLSession.shared.data(for: request)
        } catch let error as URLError {
            #if DEBUG
            print("🌐 [RakutenAPIService] リクエスト失敗。URLError発生")

            #endif
            
            switch error.code {
            case .notConnectedToInternet:
                #if DEBUG
                print("🌐 [RakutenAPIService] 接続できなかった（圏外 / 機内モード） エラーコードを取得: \(error.code)")
                #endif
                throw BookAPIError.notConnected
            case .timedOut:
                #if DEBUG
                print("🌐 [RakutenAPIService] タイムアウト エラーコードを取得: \(error.code)")
                #endif
                throw BookAPIError.timeOut // タイムアウトエラー
            default:
                #if DEBUG
                print("🌐 [RakutenAPIService] 見知らぬエラーコードを取得: \(error.code)")
                #endif
                throw BookAPIError.unknown // それ以外はunknownとして処理
            }
        } catch {
            #if DEBUG
            print("🌐 [RakutenAPIService] エラーコード以外のエラーが発生")
            print("🌐 [RakutenAPIService] エラー: \(error)")
            #endif
            throw BookAPIError.unknown // それ以外
        }

        
        /* ====== HTTPS通信のステータスに応じたJOSN取得 > BookAPISummaryへ加工 =====
             # 概要
                HTTPS通信のステータスコードに応じて処理が異なる

             # 分岐処理（手がかり → 投げるエラー Managerの対応）
                 圏外・機内モード    → notConnected    文言 → 手動
                 タイムアウト 60秒   → timeOut         OpenBD → 手動
                 200
                    空/nil        → notFound         OpenBD → 無ければ文言「見つかりません」→ 手動
                    decode失敗    → notMatchType      OpenBD → 手動(仕様変更の疑い)
                 401              → notAppToken      OpenBD → 手動(合言葉不備)
                 404              → invalidURL      OpenBD → 手動(URL不備)
                 5xx              → serverError     OpenBD → 手動(OpenBDも失敗なら文言)
                 その他            → unknown         OpenBD → 手動
                 
                 ※400(ISBN情報不備)はカメラ側で防ぐ。decodeは200のときだけ行う。
             
             # 補足
             ・ヘッダーのaddValueかsetValueの使い分けについて
             addにしなかったのは、間違って同じフィールドのaddValueを2回行わないため。行うと文字列が連結されてしまう。
         */
        
        guard let httpResponse = response as? HTTPURLResponse else {
            #if DEBUG
            print("🌐 [RakutenAPIService] httpレスポンス取得に失敗。見知らぬエラー")
            #endif
            throw BookAPIError.unknown
        }
        let decoda: RakutenAPIResponse
        
        switch httpResponse.statusCode {
            case 200:
                // catchするものは、「DecodingError」（型が不明なものがきた）とそれ以外の見知らぬエラー
                do {
                    decoda = try JSONDecoder().decode(RakutenAPIResponse.self, from: data)
                } catch let decodaError as DecodingError {
                    #if DEBUG
                    print("🌐 [RakutenAPIService] デコーダ失敗。APIの仕様変更の可能性あり: \(decodaError)")
                    #endif
                    throw BookAPIError.notMatchType
                } catch {
                    #if DEBUG
                    print("🌐 [RakutenAPIService] デコーダ失敗。見知らぬエラー")
                    #endif
                    throw BookAPIError.unknown
                }
            case 401:
                #if DEBUG
                print("🌐 [RakutenAPIService] ステータスコード 401: 合言葉不備")
                #endif
                throw BookAPIError.notAppToken
            case 404:
                #if DEBUG
                print("🌐 [RakutenAPIService] ステータスコード 404: URL系（URLの情報不備）")
                #endif
                throw BookAPIError.invalidURL
            case 500...599:
                #if DEBUG
                print("🌐 [RakutenAPIService] ステータスコード 5xx: サーバーエラー")
                #endif
                throw BookAPIError.serverError
            default:
                #if DEBUG
                print("🌐 [RakutenAPIService] 見知らぬステータスコード \(httpResponse.statusCode)")
                #endif
                throw BookAPIError.unknown
        }
        
        guard !decoda.Items.isEmpty else {
            // 結果「空」だった
            #if DEBUG
            print("🌐 [RakutenAPIService] 200系で成功 & 結果「空」だった")
            #endif
            throw BookAPIError.notFound
        }
        
        // デコーダしたデータから抽出
        guard let first = decoda.Items.first,
              let item = first.Item else {
            // 結果 nilだった
            #if DEBUG
            print("🌐 [RakutenAPIService] 200系で成功 & 結果 nilだった")
            #endif
            throw BookAPIError.notFound
        }
        
        #if DEBUG
        print("🌐 [RakutenAPIService] 取得成功！ヒットした！")
        #endif
        
        return BookAPISummary(
            isbn: item.isbn
            , title: item.title
            , author: item.author
            , publisher: item.publisherName
            , pubdate: item.salesDate
            , coverURL: item.largeImageUrl
        )
        
    }
}
