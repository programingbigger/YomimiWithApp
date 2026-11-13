//
//  SelectBookView.swift
//  YomimiApp
//
//  Created by 奈宮史典 on 2026/11/11.
//

/*
 # 役割
 名刺に載せる本を選ぶためのシート（BusinessCardView から開かれる）
 ・SwiftData に保存された本（BookRecord）を @Query で読み出して一覧表示する
 ・各本に、本詳細（BookDetailView）へ進むリンクを付けている
 
 # 位置
 【フロント側】表示が中心。読み出しは @Query が自動で行うので、Managers は通していない
 
 Views/BusinessCardView ⇨ Views/⭐️ ⇦ SwiftData(BookRecord)
 
 # 補足
 ・選んだ本を名刺に反映する処理（BookRecord.featuredOrder への保存）はまだ無い
 ・絞り込み用の selectedStatus は用意だけしてあり、切り替える UI はまだ無い
 */

import SwiftUI
import SwiftData

struct SelectBookView: View {
    
    @Environment(\.dismiss) var dismiss
    @State var searchBookTitle: String = ""
    @Query(sort: \BookRecord.createdAt, order: .reverse) private var books: [BookRecord]
    @Query(filter: #Predicate<BookRecord> { $0.featuredOrder != nil }, sort: \BookRecord.featuredOrder) var orderedbooks: [BookRecord]
    @State private var selectedStatus: ReadStatus? = nil // nilの場合は「すべて」となる
    @State private var SelectedBookIDs: [UUID] = [] // 選んだ本を格納するリスト
    @State private var isOnlySelected: Bool = false
    let MaxSelected: Int = 10
    
    // ステータスに応じて表示する本一覧を制限
    private var filteredBooks: [BookRecord] {
        // ステータスで絞られた時
        if let status = selectedStatus {
            return books.filter { $0.status == status }
        }
        
        // 名刺として選択された本のみ
        else if isOnlySelected {
            return orderedbooks
        }
        
        // 全て表示
        else {
            return books
        }
    }
    
    // 本の選択に応じた関数
    private func toggleSelection(book: BookRecord) {
        if let i = SelectedBookIDs.firstIndex(of: book.id) {
            SelectedBookIDs.remove(at: i)
            book.featuredOrder = nil
        } else if SelectedBookIDs.count < MaxSelected {
            SelectedBookIDs.append(book.id)
            book.featuredOrder = SelectedBookIDs.firstIndex(of: book.id)
        }
    }
    
    var body: some View {
        
        NavigationStack {
            VStack {
                
                Divider()
                
                // 検索窓
                TextField("タイトル・著者で検索", text: $searchBookTitle)
                    .padding()
                    .background(Color(.appSurface))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .padding()
                
                // タグ &　絞り込み
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        StatusFilterChip(
                            title: "すべて"
                            , count: books.count
                            , color: nil
                            , isSelected: selectedStatus == nil) {
                                selectedStatus = nil
                            }
                        
                        ForEach(ReadStatus.allCases, id: \.self) { status in
                            StatusFilterChip(
                                title: status.label
                                , count: books.filter { $0.status == status }.count
                                , color: status.color
                                , isSelected: selectedStatus == status) {
                                    selectedStatus = status
                                }
                        }
                    }
                    .padding(.horizontal)
                }
                
                //ヒント
                Text("💡読み終わったら「読中」→本をタップ→ステータス変更")
                
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
                                
                                Button {
                                    toggleSelection(book: book)
                                    
                                } label: {
                                    // 1冊の本の表紙を描画
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
                                    .overlay {
                                        if let index = SelectedBookIDs.firstIndex(of: book.id)  {
                                            ZStack {
                                                RoundedRectangle(cornerRadius: 20)
                                                    .fill(Color.white)
                                                    .frame(maxWidth: 100, alignment: .leading)
                                                Text("\(index + 1)")
                                            }
                                        }

                                    }
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                    .padding(.bottom, 20) // 本タブのための余白
                }
                
                
                Divider()
                
                // 本選択状況
                VStack {
                    // 選択状況
                    HStack {
                        Text("10冊中\(SelectedBookIDs.count)を選択中")
                        Spacer()
                        
                        // カスタムボタンを作成する必要がある
                        Button {
                            isOnlySelected.toggle()
                        } label: {
                            Text("選択中だけ見る")
                        }
                    }
                    // 本を自己紹介画面へ反映ボタン（カスタムボタンを作成する必要がある）
                    Button {
                        
                    } label: {
                        Text("本をタップして選んでね")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color.accentColor)
                            .cornerRadius(12)
                    }
                }
            }
            .padding(20)
            .navigationTitle("名刺の本を選ぶ")
            .navigationBarTitleDisplayMode(.inline)
            .background(Color("AppBackground"))
            .navigationBarBackButtonHidden(true) // 「<」 マークの削除
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("キャンセル") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    SelectBookView()
}
