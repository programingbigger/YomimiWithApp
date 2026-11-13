//
//  BookSummary.swift
//  YomimiApp
//
//  Created by 奈宮史典 on 2026/09/29.
//

import Foundation

// どのAPI(openBD/Google Books/楽天)を使っても、**最終的にこの形に揃えるアプリ内の共通の型**
// 呼び出す側(BarcodeScannerViewなど)は、これだけ知っていればいい
struct BookAPISummary {
    let isbn: String? // isbnコード
    let title: String? // 本のタイトル
    let author: String? // 著者名
    let publisher: String? // 出版社
    let pubdate: String? // 出版年月
    let coverURL: String? // 書影URL（カバー画像を表示するためのもの）
    
    // ページ数も入れたい・・・
}
