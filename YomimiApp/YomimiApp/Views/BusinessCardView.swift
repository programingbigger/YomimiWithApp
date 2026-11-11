//
//  BusinessCardView.swift
//  YomimiApp
//
//  Created by 奈宮史典 on 2026/04/06.
//　S-06〜08　名刺（プレビュー・選択・シェア）

import SwiftUI

struct BusinessCardView: View {
    
    @State var isShowingSelectBookView: Bool = false
    @State var SelectCount: Int = 0
    
    var body: some View {
        
        NavigationStack {
            
            Divider()
            
            Spacer()
            
            ZStack {
                
                //白い背景下地の作成
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white)
                    .shadow(color: .black.opacity(0.08), radius: 8, y:2)
                    .padding(16)
                
                // 名刺代わりの本10選作成UI
                VStack {
                    
                    // 見出し
                    Text("名刺代わりの本 / 小説を選ぼう")
                        .font(.title2)
                        .foregroundStyle(.textPrimary)
                    Text("小説だけを選んでもOK。")
                    Text("ハッシュタグはシェアの時に選べます")
                    
                    // 10冊中、いくつ選んだか？
                    Text("10冊中\(String(SelectCount))冊を選択中")
                    
                    // 10選本棚
                    LazyVGrid(columns: [GridItem(), GridItem(), GridItem()]) {
                        ForEach(0..<10) { _ in
                            Button {
                                isShowingSelectBookView = true
                                SelectCount += 1
                            } label: {
                                Capsule()
                                    .frame(width: 90, height: 120)
                                    .background(Color.appBorder)
                                    .clipShape(RoundedRectangle(cornerRadius: 6))
                            }
                        }
                        .sheet(isPresented: $isShowingSelectBookView) {
                            SelectBookView()
                                .presentationDetents([.large])
                            }
                    }
                    
                    // Xシェアボタン
                    Button {
                        isShowingSelectBookView = true
                        SelectCount += 1
                    } label: {
                        Text("📚名刺代わりの本を選ぼう")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color.accentColor)
                            .cornerRadius(12)
                    }
                    .sheet(isPresented: $isShowingSelectBookView) {
                        SelectBookView()
                            .presentationDetents([.large])
                    }
                }
                .padding(30)
            }
            .navigationTitle("🪪名刺代わりの本10選")
            .navigationBarTitleDisplayMode(.inline)
            .padding(.bottom, 20) // タブのための余白
            
        }
        .frame(maxWidth: .infinity,  maxHeight: .infinity)
        .background(Color("AppBackground"))
    }
}

#Preview {
    BusinessCardView()
}
