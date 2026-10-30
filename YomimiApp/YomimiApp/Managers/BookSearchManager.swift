//
//  BookSearchManager.swift
//  YomimiApp
//
//  Created by 奈宮史典 on 2026/09/30.
//

/*
 # 役割
 Service（受け取り・変換）とVIews（表示）の間にたつ司令塔
 ・Servicesに「この本を取ってきて」と頼む
 ・結果を画面が使いやすい状態（読み込み中 / 成功 / error）にして持つ
 
 Services/ ⇨ Managers/⭐️ ⇨ Views/
 */

import Foundation

@Observable
class BookSearchManager {
    
    // どのAPIを使うかは、この1行だけで決定する
    private let OpenBDAPIServices: BookAPIService = OpenBDService()
    private let RakutenAPIServices: BookAPIService = RakutenAPIService()
    
    // 画面に見せる状態
    var scannedISBN: String?        // 読み取ったISBN
    var BookAPISummary: BookAPISummary?   // 取得できた本の情報
    var isLoading = false           // 取得中かどうか
    var errorMessage: String?       // 画面に出すエラー文章
    
    // ISBNを受け取って、本の情報を取得する
    func search(isbn:String) async {
        #if DEBUG
        print("🟣 [BookSearchManager] 検索開始: \(isbn)")
        #endif
        
        // （初期化）前回の結果をリセット
        scannedISBN = isbn
        BookAPISummary = nil
        errorMessage = nil
        
        // 検索処理
        isLoading = true
        
        do {
            #if DEBUG
            print("🟣 [BookSearchManager] 楽天BookAPIを叩く")
            #endif
            BookAPISummary = try await RakutenAPIServices.fetchBookInfo(isbn: isbn)
        } catch let error as BookAPIError {
            switch error {
            case .notConnected:
                errorMessage = "インターネットに接続されていません"
            case .timeOut:
                errorMessage = "タイムアウト"
            case .notFound, .notMatchType, .notAppToken, .invalidURL, .serverError, .unknown:
                #if DEBUG
                print("🟣 [BookSearchManager] 楽天で本が見つからなかったため、BookBDAPIを叩く")
                #endif
                
                do {
                    BookAPISummary = try await OpenBDAPIServices.fetchBookInfo(isbn: isbn)
                } catch let error as BookAPIError {
                    switch error {
                    case .invalidURL:
                        errorMessage = "この本は見つかりませんでした"
                    case .notFound:
                        errorMessage = "この本は見つかりませんでした"
                    default:
                        errorMessage = "この本は見つかりませんでした"
                    }
                } catch {
                    errorMessage = "この本は見つかりませんでした"
                }
            }
        } catch {
            do {
                BookAPISummary = try await OpenBDAPIServices.fetchBookInfo(isbn: isbn)
            } catch let error as BookAPIError {
                switch error {
                case .invalidURL:
                    errorMessage = "この本は見つかりませんでした"
                case .notFound:
                    errorMessage = "この本は見つかりませんでした"
                default:
                    errorMessage = "この本は見つかりませんでした"
                }
            } catch {
                errorMessage = "この本は見つかりませんでした"
            }
        }
        
        // 検索終了
        isLoading = false
        #if DEBUG
        print("🟣 [BookSearchManager] 検索終了")
        #endif
    }
    
    // 予備のOpenBDAPIを叩く処理
    
}

