//
//  BookDetailView.swift
//  YomimiApp
//
//  Created by 奈宮史典 on 2026/04/06.
//　S-05　本詳細

import SwiftUI

// 白いカード（小見出し + 中身）
private struct DetailSection<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(Color(.textSecondary))
                .padding(.horizontal, 14)
                .padding(.top, 10)
                .padding(.bottom, 6)
            content
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.appSurface))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color(.appBorder)))
    }
}

// 白いカードの中にあるcontent
// 書籍情報のカラム名 + 書籍から首藤した情報を載せる
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
                .foregroundStyle(Color(.textSecondary))
                .frame(width: 70, alignment: .leading)
            Text(displayValue)
                .font(.body)
        }
    }
}

// 詳細画面（本体）
struct BookDetailView: View {
    
    // 書籍情報の読み取り
    @Bindable var book: BookRecord
    
    // 感想を記載するメモ欄
    private var memoBinding: Binding<String> {
        Binding(
            get: { book.memo ?? ""},
            set: { book.memo = $0.isEmpty ? nil : $0 }
        )
    }
        
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
                
                // メモ
                DetailSection(title: "📝 メモ（感想や思ったことを記録しよう！）") {
                    TextEditor(text: memoBinding)
                        .frame(minHeight: 120)
                        .scrollContentBackground(.hidden)
                        .padding(.horizontal, 10)
                        .padding(.bottom, 8)
                }
                
                // おすすめ度
                DetailSection(title: "読書記録") {
                    StarRatingView(rating: $book.rating)
                        .padding(.horizontal, 10)
                        .padding(.bottom, 8)
                }
                
                // 書籍情報
                DetailSection(title: "書籍情報") {
                    VStack(alignment: .leading, spacing: 12) {
                        DetailRow(label: "著者", value: book.author)
                        DetailRow(label: "出版社", value: book.publisher)
                        DetailRow(label: "出版年月", value: book.publishedDate)
                        DetailRow(label: "ページ数", value: book.pageCount.map { "\($0)ページ" })
                        DetailRow(label: "ジャンル", value: book.genre)
                    }
                    .padding(.horizontal, 14)
                    .padding(.bottom, 12)
                }
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
