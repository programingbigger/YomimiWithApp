//
//  Book.swift
//  YomimiApp
//
//  Created by 奈宮史典 on 2026/09/30.
//

// Models/Book.swift
import Foundation
import SwiftData

@Model
final class BookRecord {
    @Attribute(.unique) var id: UUID   // 将来のFirebase連携用（仕様書 3.2）
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
    var isFeatured: Bool               // 名刺10冊フラグ
    var createdAt: Date
    var updatedAt: Date
    
    // ④ 育成用のOptional（値の取得は後回し。器だけ先に用意）
    var pageCount: Int?
    var ndc10: String?
    var cCode: String?
    var subjectText: [String]?
    
    init(
        id: UUID = UUID(),
        isbn: String? = nil,
        title: String,
        author: String = "",
        publisher: String? = nil,
        publishedDate: String? = nil,
        genre: String? = nil,
        thumbnailURL: String? = nil,
        status: ReadStatus = .tsundoku,
        finishedDate: Date? = nil,
        rating: Int? = nil,
        memo: String? = nil,
        isFeatured: Bool = false,
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
        self.isFeatured = isFeatured
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.pageCount = pageCount
        self.ndc10 = ndc10
        self.cCode = cCode
        self.subjectText = subjectText
    }
}


