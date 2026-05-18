//
//  BookManualRegisterView.swift
//  YomimiApp
//
//  Created by 奈宮史典 on 2026/04/06.
//　S-04　手動登録

import SwiftUI

struct BookRegistrationView: View {
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack() {
            
            ScrollView {
                
                Divider()
                
                
                VStack {
                    
                    // 登録できなかったことのアラート
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.green) // 失敗時は黄色
                            .opacity(0.2)
                            .frame(height: 80)
                        HStack {
                            Capsule()
                                .frame(width: 50, height: 50)
                            
                            // 成功時
                            Text("バーコードから取得しました。内容を確認して登録してください。")
                            // 失敗時
                            //                            Text("バーコードの読み取りに失敗しました。\n情報を手動で入力してください。")
                        }
                    }
                    .padding(16)
                    
                    // 本の表紙など
                    HStack() {
                        Capsule()
                            .frame(width: 100, height: 150)
                        
                        VStack(alignment: .leading) {
                            Text("本のタイトル")
                                .font(.title3)
                            Text("著者 / 出版社 / 出版日")
                            Capsule()
                                .frame(width: 150, height: 20)
                        }
                    }
                    .padding(16)
                    
                    // 必須項目
                    VStack {
                        HStack {
                            Text("必須項目")
                            Spacer()
                        }
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.white)
                                .shadow(color: .black.opacity(0.08), radius: 8, y:2)
                                .frame(height: 150)
                            VStack {
                                Text("タイトル") // 入力できるボックスに
                                Text("著者名")
                            }
                        }
                    }
                    .padding(16)
                    
                    
                    // 任意項目
                    VStack {
                        HStack {
                            Text("任意項目")
                            Spacer()
                        }
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.white)
                                .shadow(color: .black.opacity(0.08), radius: 8, y:2)
                                .frame(height: 150)
                            VStack {
                                Text("出版社")
                                Text("ジャンル")
                                Text("感想や気づきを入力")
                                Text("オススメ度") // 星 or 小数点第2位くらいまで入力できるような形へ
                            }
                        }
                    }
                    .padding(16)
                    
                    // 本の情報 手動登録ボタン
                    Button {
                        
                    } label: {
                        Text("📚本棚に登録する")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundStyle(.white)
                            .frame(width: 150)
                            .padding(.vertical, 16)
                            .background(Color("AccentColor"))
                            .cornerRadius(12)
                    }
                }
            }
            .navigationTitle("本を手動で登録")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Label("× 閉じる", image: "xmark")
                    }
                }
            }
        }
        .frame(maxWidth: .infinity,  maxHeight: .infinity)
        .background(Color("AppBackground"))
    }
}

#Preview {
    BookRegistrationView()
}
