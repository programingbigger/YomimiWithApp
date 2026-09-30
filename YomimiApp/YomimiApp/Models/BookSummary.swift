//
//  BookSummary.swift
//  YomimiApp
//
//  Created by 奈宮史典 on 2026/09/29.
//

import Foundation

// どのAPI(openBD/Google Books/楽天)を使っても、**最終的にこの形に揃えるアプリ内の共通の型**
// 呼び出す側(BarcodeScannerViewなど)は、これだけ知っていればいい
struct BookSummary {
    let isbn: String?
    let title: String?
    let author: String?
    let publisher: String?
    let pubdate: String?
    let coverURL: String?
}
