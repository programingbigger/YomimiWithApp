//
//  BookAPIService.swift
//  YomimiApp
//
//  Created by 奈宮史典 on 2026/09/20.
//

import Foundation


// ①どのAPI(openBD/Google Books/楽天)を使っても、最終的にこの形に揃える共通の型
//   呼び出す側(BarcodeScannerViewなど)は、これだけ知っていればいい
struct BookSummary {
    let isbn: String?
    let title: String?
    let author: String?
    let publisher: String?
    let pubdate: String?
    let coverURL: String?
}

// 2「ISBNを渡したら、書籍情報を返してくれること」という契約(プロトコル)
//   ScannerViewControllerDelegateの時と同じ考え方。中身は無く、ルールだけ
protocol BookAPIService {
    func fetchBookInfo(isbn: String) async throws -> BookSummary
}

// ３　共通で使うエラーの種類
enum BookAPIError: Error {
    case invaidURL
    case notFound
}

/*
 ④今後の切り替え候補（今は実装しない、設計イメージだけ置いておく）
 
 // Google Books APIを使う場合
 struct GoogleBooksService: BookAPIService {
 func fetchBookInfo(isbn: String) async throws -> BookSummary {
 // let url = URL(string: "https://www.googleapis.com/books/v1/volumes?q=isbn:\(isbn)")
 // ...Google Books特有のJSON形式をBookSummaryに変換する処理...
 }
 }
 
 // 楽天ブックスAPIを使う場合
 struct RakutenBooksService: BookAPIService {
 let applicationId: String
 func fetchBookInfo(isbn: String) async throws -> BookSummary {
 // let url = URL(string: "https://app.rakuten.co.jp/services/api/BooksBook/Search/20170404?format=json&isbn=\(isbn)&applicationId=\(applicationId)")
 // ...楽天特有のJSON形式をBookSummaryに変換する処理...
 }
 }
 */
