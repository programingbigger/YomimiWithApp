//
//  SelectBookView.swift
//  YomimiApp
//
//  Created by 奈宮史典 on 2026/11/11.
//

import SwiftUI
import SwiftData

struct SelectBookView: View {
    
    @Query(sort: \BookRecord.createdAt, order: .reverse) private var books: [BookRecord]
    @State private var selectedStatus: ReadStatus? = nil // nilの場合は「すべて」となる
    
    
    // 本に対するステータスで絞った場合と「すべて」の場合の分岐
    private var filteredBooks: [BookRecord] {
        
        if let status = selectedStatus {
            return books.filter { $0.status == status }
        } else {
            return books
        }
    }
    
    var body: some View {
        // 本棚一覧
        if filteredBooks.isEmpty {
            ContentUnavailableView(
                books.isEmpty ? "まだ本がありません" : "この条件の本はありません"
                , systemImage: "books.vertical"
                , description: Text(books.isEmpty ? "下のカメラボタンから、最初の１冊を登録しよう！" : "別のタグを選ぶか、「すべて」に戻してください")
            )
        } else {
            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible(), alignment: .top)
                                    , GridItem(.flexible(), alignment: .top)
                                    , GridItem(.flexible(), alignment: .top)]) {
                    ForEach(filteredBooks) { book in
                        NavigationLink {
                            BookDetailView(book: book)
                        } label: {
                            VStack(alignment: .leading) {
                                
                                // 書影
                                BookCoverView(title: book.title, thumbnailURL: book.thumbnailURL)
                                    .frame(width: 100, height: 150)
                                
                                // 書籍タイトル
                                Text(book.title)
                                    .font(.caption) // キャプションモード
                                    .lineLimit(2) // 最大2行に制限
                                
                                // ステータスバッジ(読みたい!や読了など)
                                StatusBadgeView(status: book.status)
                            }
                            .frame(maxWidth: 100, alignment: .leading)
                            
                        }
                        .buttonStyle(.plain) // リンクの青文字化を防ぐ
                    }
                }
            }
            .padding(.bottom, 20) // 本タブのための余白
        }
    }
}

#Preview {
    SelectBookView()
}
