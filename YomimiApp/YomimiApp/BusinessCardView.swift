//
//  BusinessCardView.swift
//  YomimiApp
//
//  Created by 奈宮史典 on 2026/04/06.
//　S-06〜08　名刺（プレビュー・選択・シェア）

import SwiftUI

struct BusinessCardView: View {
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
                    
                    // 選択した本の冊数
                    Text("10冊中 8冊を選択中")
                    
                    // 10選本棚
                    LazyVGrid(columns: [GridItem(), GridItem(), GridItem(),  GridItem()]) {
                        ForEach(0..<10) { _ in
                            Capsule()
                                .frame(width: 90, height: 120)
                        }
                    }
                    
                    // コメント
                    Text("読書が好きで、夜景や光のある話が特に好きです✨本を通じて色んな人と繋がりたいです！")
                    
                    // Xシェアボタン
                    Button {
                        
                    } label: {
                        Text("Xでシェア")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color.blue)
                            .cornerRadius(12)
                    }
                }
                .padding(30)
            }
            .navigationTitle("🪪名刺代わりの本10選")
            .navigationBarTitleDisplayMode(.inline)
            .padding(.bottom, 20) // タブのための余白
            
        }
        .background(Color("AppBackground"))
        .frame(maxWidth: .infinity,  maxHeight: .infinity)
    }
}

#Preview {
    BusinessCardView()
}
