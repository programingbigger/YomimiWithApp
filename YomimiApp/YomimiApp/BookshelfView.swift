//
//  ContentView.swift
//  YomimiApp
//
//  Created by 奈宮史典 on 2026/04/06.
//　S-01　本棚（ホーム）

import SwiftUI

struct BookshelfView: View {
    
    @State var searchBookTitle: String = ""
    
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
                        ForEach(0..<100) { _ in
                            VStack(alignment: .leading) {
                                Capsule()
                                    .frame(width: 100, height: 150)
                                Text("本のタイトル")
                            }
                            .padding()
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
