//
//  BookRegistrationManager.swift
//  YomimiApp
//
//  Created by 奈宮史典 on 2026/10/01.
//

/*
 # 役割
 登録ボタンが押されたときの司令塔
 ・入力チェック（タイトル必須）
 ・ISBNの重複チェック
 ・SwiftDataへ保存
 ・失敗したら画面に出す文言を持つ
 
 Views/(登録ボタン) ⇨ Managers/⭐️ ⇨ SwiftData()
 */

import Foundation
import SwiftData // データを永続化するためのフレームワーク
import Observation

@Observable
final class BookRegistrationManager {
    var errorMessage: String?
    
    // 同じISBNがすでに保存されているか？の判定関数
    private func isDuplicate(isbn: String, in context: ModelContext) throws -> Bool {
        let target: String? = isbn
        var descriptor = FetchDescriptor<BookRecord>(
            predicate: #Predicate { $0.isbn == target }
        )
        descriptor.fetchLimit = 1
        return try context.fetchCount(descriptor) > 0
    }
    
    // 登録に成功したら true。失敗したら false。error原因は、errorMessageに入る
    func register(_ book: BookRecord, in context: ModelContext) -> Bool {
        errorMessage = nil
        
        // （必須項目）タイトル
        let trimmedTitle = book.title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedTitle.isEmpty else {
            errorMessage = "タイトルを入力してください"
            return false
        }
        book.title = trimmedTitle
        
        // 読了日は「読了」の時だけ表示する
        if book.status != .finished {
            book.finishedDate = nil
        }
        
        // ISBNがある場合だけ重複チェック
        if let isbn = book.isbn, !isbn.isEmpty {
            do {
                if try isDuplicate(isbn: isbn, in:context) {
                    errorMessage = "この本はすでに登録されています"
                    return false
                }
            } catch {
                errorMessage = "登録に失敗しました"
                return false
            }
        }
        
        // 保存
        context.insert(book)
        do {
            try context.save()
            return true
        } catch {
            errorMessage = "登録に失敗しました"
            return false
        }
    }

}
