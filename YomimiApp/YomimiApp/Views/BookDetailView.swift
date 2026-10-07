//
//  BookDetailView.swift
//  YomimiApp
//
//  Created by 奈宮史典 on 2026/04/06.
//　S-05　本詳細

import SwiftUI

private struct DetailRow: View {
    
    let label: String
    let value: String?
    
    private var displayValue: String {
        guard let value, !value.isEmpty else { return "ー" }
        return value
    }
    
    var body: some View {
        HStack(alignment: .top) {
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
                .frame(width: 70, alignment: .leading)
            Text(displayValue)
                .font(.body)
        }
    }
}

struct BookDetailView: View {
    
    let book: BookRecord
        
    var body: some View {
        
        ScrollView {
            VStack(spacing: 16) {
                
                // 表紙・タイトル・ステータス
                BookCoverView(title:  book.title
                              , thumbnailURL: book.thumbnailURL
                              , width: 150
                              , height: 225
                )
                Text(book.title)
                    .font(.title2)
                    .bold()
                    .multilineTextAlignment(.center)
                StatusBadgeView(status: book.status)
                
                // 書籍情報
                VStack(alignment: .leading, spacing: 12) {
                    DetailRow(label: "著者", value: book.title)
                    DetailRow(label: "出版社", value: book.publisher)
                    DetailRow(label: "出版年月", value: book.publishedDate)
                    DetailRow(label: "ページ数", value: book.pageCount.map { "\($0)ページ" })
                    DetailRow(label: "ジャンル", value: book.genre)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color(.appSurface))
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .padding()
        }
        .background(Color(.appBackground))
        .navigationTitle("本詳細")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        BookDetailView(book: BookRecord(title: "プレビュー用の本",
                                        author: "著者名",
                                        publisher: "出版社",
                                        publishedDate: "202004",
                                        genre: nil,
                                        pageCount: nil))
    }
}
