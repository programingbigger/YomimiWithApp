//
//  BookSummary.swift
//  YomimiApp
//
//  Created by 奈宮史典 on 2026/09/29.
//

/*
 # 役割
 API から取ってきた本の情報を入れる、アプリ内共通の「箱（型）」
 ・楽天 / openBD など API ごとに形が違っても、Services がこの形に揃えて返す
 ・保存はされない一時的なデータ（保存用の型は BookRecord）
 
 # 位置
 【データの型】フロント側でも処理側でもなく、両者の間を運ばれる「荷物」
 
 Services/（⭐️の形に変換）⇨ Managers/BookSearchManager ⇨ Views/BarcodeScannerView ⇨ Views/BookRegistrationView
 */

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
