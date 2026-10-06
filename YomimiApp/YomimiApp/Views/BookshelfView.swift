//
//  ContentView.swift
//  YomimiApp
//
//  Created by 奈宮史典 on 2026/04/06.
//　S-01　本棚（ホーム）

import SwiftUI
import SwiftData

struct BookshelfView: View {
    
    @State var searchBookTitle: String = ""
    
    @Query(sort: \BookRecord.createdAt, order: .reverse) private var books: [BookRecord]
    
    var body: some View {
        NavigationStack {
            
            Text("登録数: \(books.count)")
            
            VStack {
                
                Divider()
                
                // 検索窓
                TextField("タイトル・著者で検索", text: $searchBookTitle)
                    .padding()
                    .background(Color(.appSurface))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .padding()
                
                // タグ &　絞り込み
                HStack() {
                    Text("すべて")
                    Text("未読5")
                    Text("読中3")
                    Text("読了4")
                }
                
                //ヒント
                Text("💡読み終わったら「読中」→本をタップ→ステータス変更")
                
                // 本棚一覧
                ScrollView {
                    LazyVGrid(columns: [GridItem(), GridItem(), GridItem()]) {
                        ForEach(books) { book in
                            NavigationLink {
                                BookDetailView(book: book)
                            } label: {
                                VStack(alignment: .leading) {
                                    Capsule()
                                        .frame(width: 100, height: 150)
                                    Text(book.title)
                                        .font(.caption) // キャプションモード
                                        .lineLimit(2) // 最大2行に制限
                                }
                            }
                            .buttonStyle(.plain) // リンクの青文字化を防ぐ
                        }
                    }
                }
                .padding(.bottom, 20) // 本タブのための余白
                
                
                Divider()
                
            }
            .navigationTitle("📚本棚")
            .navigationBarTitleDisplayMode(.inline)
            .background(Color("AppBackground"))
        }
    }
}

#Preview {
    BookshelfView()
}
