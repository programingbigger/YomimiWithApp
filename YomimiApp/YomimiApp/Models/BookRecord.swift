//
//  Book.swift
//  YomimiApp
//
//  Created by 奈宮史典 on 2026/09/30.
//

/*
 # 役割
 本棚に登録する本1冊分のデータの「設計図」。SwiftData に保存される形
 ・タイトル / 著者 / ステータス / メモ / おすすめ度 などを持つ
 ・@Model が付いているので、このクラスがそのまま保存対象になる
 
 # 位置
 【データの型】フロント側でも処理側でもなく、両方から使われる
 
 Views/BookRegistrationView（⭐️を作る）⇨ Managers/BookRegistrationManager（保存）⇨ SwiftData()
 SwiftData() ⇨ Views/BookshelfView・BookDetailView（⭐️を読み出して表示・編集）
 */

/*
 
 ＜BookRecordクラスについて＞
 ・呼び出す際に、titleは必須項目
 ・status, createdat, updateat, idは必ず値が入る
    ・statusは初期値は、「積読」(.tsundoku)
 
 */



// Models/Book.swift
import Foundation
import SwiftData

@Model // このクラスをSwiftDataの保存対象にする
final class BookRecord {
    
    // 型定義
    @Attribute(.unique) var id: UUID   // 将来のFirebase連携用（仕様書 3.2）Attribute(.hogehoge)が特殊なルールを付ける
    var isbn: String?
    var title: String
    var author: String
    var publisher: String?
    var publishedDate: String?         // ISO8601
    var genre: String?
    var thumbnailURL: String?
    var status: ReadStatus
    var finishedDate: Date?
    var rating: Int?                   // 1〜5
    var memo: String?
    var featuredOrder: Int? // 名刺代わりの10冊。1〜10の数字は並び順兼名刺代わりとして選んでいるフラグ
    var createdAt: Date
    var updatedAt: Date
    
    // ④ 育成用のOptional（値の取得は後回し。器だけ先に用意）
    var pageCount: Int?
    var ndc10: String?
    var cCode: String?
    var subjectText: [String]?
    
    
    // 初期化（BookRecordが呼ばれた時の状態）
    init(
        id: UUID = UUID(),
        isbn: String? = nil,
        title: String, // titleは必須だから、このクラスを呼び出すための必要条件 ⇨ 値を必ず入れる設定にさせる
        author: String = "", // 初期値はnilではなく、空文字が入る
        publisher: String? = nil,
        publishedDate: String? = nil,
        genre: String? = nil,
        thumbnailURL: String? = nil,
        status: ReadStatus = .tsundoku,
        finishedDate: Date? = nil,
        rating: Int? = nil,
        memo: String? = nil,
        featuredOrder: Int? = nil,
        createdAt: Date = .now,
        updatedAt: Date = .now,
        pageCount: Int? = nil,
        ndc10: String? = nil,
        cCode: String? = nil,
        subjectText: [String]? = nil
    ) {
        self.id = id
        self.isbn = isbn
        self.title = title
        self.author = author
        self.publisher = publisher
        self.publishedDate = publishedDate
        self.genre = genre
        self.thumbnailURL = thumbnailURL
        self.status = status
        self.finishedDate = finishedDate
        self.rating = rating
        self.memo = memo
        self.featuredOrder = featuredOrder
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.pageCount = pageCount
        self.ndc10 = ndc10
        self.cCode = cCode
        self.subjectText = subjectText
    }
}


