//
//  BusinessCardView.swift
//  YomimiApp
//
//  Created by 奈宮史典 on 2026/04/06.
//　S-06〜08　名刺（プレビュー・選択・シェア）

/*
 # 役割
 「名刺代わりの本10選」を作る画面（S-06〜08 名刺）
 ・10個の枠と「名刺代わりの本を選ぼう」ボタンを表示する
 ・枠やボタンを押すと、本を選ぶシート（SelectBookView）を開く
 
 # 位置
 【フロント側】現在は見た目とシートの開閉のみ（データの取得・保存はしていない）
 
 Views/HomeView（名刺タブ）⇨ Views/⭐️ ⇨ Views/SelectBookView
 
 # 補足
 選択数（SelectCount）は押した回数を数えているだけで、実際に選んだ本とはまだ連動していない
 */

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
                        ForEach(0 ..< 10) { index in
                            Button {
                                isShowingSelectBookView = true
                                SelectCount += 1
                            } label: {
                                
                                ZStack {
                                    RoundedRectangle(cornerRadius: 6)
                                        .fill(Color.appBorder)
                                        .frame(width: 90, height: 120)
                                        .opacity(0.5)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 6)
                                                .stroke(style: StrokeStyle(lineWidth: 1.5, dash: [6, 4]))
                                                .opacity(0.5)
                                        )
                                    VStack {
                                        Text("+")
                                            .padding(3)
                                        Text("\(index+1)")
                                    }
                                    .foregroundStyle(Color.textSecondary)
                                }
                                

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
                        Text("📚名刺代わりの本を選ぶ")
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
