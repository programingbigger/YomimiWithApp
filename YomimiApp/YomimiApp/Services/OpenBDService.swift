//
//  OpenBDService.swift
//  YomimiApp
//
//  Created by 奈宮史典 on 2026/09/20.
//

import Foundation

// 1 OpenBD側のみから受け取る型
private struct OpenBDSummary: Decodable {
    let isbn: String?
    let title: String?
    let author: String?
    let publisher: String?
    let pubdate: String?
    let cover: String?
}

// openBDは配列で帰ってくる & 見つからない場合を踏まえ、オプショナル型
private struct OpenBDResponse: Decodable {
    let summary: OpenBDSummary?
}



// 2　ISBNを受け取って、openBDを叩き、bookの情報を返す関数
struct OpenBDService: BookAPIService {
    func fetchBookInfo(isbn: String) async throws -> BookSummary {
        guard let url = URL(string: "https://api.openbd.jp/v1/get?isbn=\(isbn)") else {
            throw BookAPIError.invalidURL // 文字列からURLを組み立てられなかった場合にエラーを投げる
        }
        #if DEBUG
        print("🌐 [OpenBDService] リクエスト開始: \(url)")
        #endif
        
        // API叩く処理 + 生データ受信する処理（この一行に含まれる）
        let(data, _) = try await URLSession.shared.data(from: url)
        #if DEBUG
        print("🌐 [OpenBDService] 生データ受信: \(data.count) bytes")
        #endif
        
        // 生データを加工する処理（JSON + Swiftの型へ変換）
        let decoded = try JSONDecoder().decode([OpenBDResponse?].self, from: data)
        
        guard let response = decoded.first,            // １配列に1個目の要素はある？
              let summary = response?.summary else {   // ２その中に summary はある？もし nil の場合はエラー notFound を返す
                    #if DEBUG
                    print("🟥 [OpenBDService] 該当書籍が見つかりませんでした")
                    #endif
                    throw BookAPIError.notFound
                }
                #if DEBUG
                print("🟩 [OpenBDService] 取得成功: \(summary.title ?? "無題")")
                #endif
        
        //openBD独自の形式(summary) ⇨ 共通のBookSummaryへ変換する
        return BookSummary(
            isbn: summary.isbn,
            title: summary.title,
            author: summary.author,
            publisher: summary.publisher,
            pubdate: summary.pubdate,
            coverURL: summary.cover
        )
    }
}
