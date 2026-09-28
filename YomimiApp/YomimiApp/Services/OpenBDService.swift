//
//  OpenBDService.swift
//  YomimiApp
//
//  Created by 奈宮史典 on 2026/09/20.
//

import Foundation

// １ openBDのレスポンス（"summary"部分だけ）を受け取る型
// openBDは配列で帰ってくる & 見つからない場合は、nilを返す
// そのため、オプショナル型にしている
private struct OpenBDResponse: Decodable {
    let summary: OpenBDSummary?
}

struct OpenBDSummary: Decodable {
    let isbn: String?
    let title: String?
    let author: String?
    let publisher: String?
    let pubdate: String?
    let cover: String?
}

//　２　発生しうるエラーの種類を自分たちで定義
enum OpenBDError: Error {
    case invalidURL
    case notFound
}

// ３　ISBNを受け取って、openBDを叩き、bookの情報を返す関数
struct OpenBDService: BookAPIService {
    func fetchBookInfo(isbn: String) async throws -> BookSummary {
        guard let url = URL(string: "https://api.openbd.jp/v1/get?isbn=\(isbn)") else {
            throw OpenBDError.invalidURL // 見つからない場合はURLが見つからないエラーを返す
        }
        #if DEBUG
        print("🌐 [fetchBookInfo] リクエスト開始: \(url)")
        #endif
        
        // API叩く処理 + 生データ受信処理（この一行に含まれる）
        let(data, _) = try await URLSession.shared.data(from: url)
        #if DEBUG
        print("🌐 [fetchBookInfo] 生データ受信: \(data.count) bytes")
        #endif
        
        // 生データを加工する処理（JSON + Swiftの型へ変換）
        let decoded = try JSONDecoder().decode([OpenBDResponse?].self, from: data)
        
        guard let first = decoded.first,
              let response = first,
              let summary = response.summary else {
            #if DEBUG
            print("🟥 [fetchBookInfo] 該当書籍が見つかりませんでした")
            #endif
            throw OpenBDError.notFound
        }
        
        #if DEBUG
        print("🟩 [fetchBookInfo] 取得成功: \(summary.title ?? "無題")")
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
