//
//  BookAPIService.swift
//  YomimiApp
//
//  Created by 奈宮史典 on 2026/09/20.
//

import Foundation


// 1「ISBNを渡したら、書籍情報を返してくれること」という契約(プロトコル)
//   ScannerViewControllerDelegateの時と同じ考え方。中身は無く、ルールだけ
protocol BookAPIService {
    func fetchBookInfo(isbn: String) async throws -> BookAPISummary
}

// 2　共通で使うエラーの種類（Errorはプロトコル）
enum BookAPIError: Error {
    case invalidURL // URL系（URL の文字列が作れない / URLの情報不備）
    case notAppToken // 合言葉不備
    case notFound // 本が見つからなかったとき
    case notConnected // 通信系（圏外 / 機内モード）
    case timeOut // タイムアウト
    case serverError // 5xx系
    case notMatchType // 予期していない型
    case unknown // 予期していない
}
