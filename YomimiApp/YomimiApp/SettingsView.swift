//
//  SettingsView.swift
//  YomimiApp
//
//  Created by 奈宮史典 on 2026/04/06.
//　S-09　設定

import SwiftUI

struct SettingsView: View {
    var body: some View {

        
        NavigationStack {
            
            Divider()
            
            Spacer()
            
            ScrollView {
                VStack {
                    
                    // プロフィール トップ
                    ZStack {
                        // 背景下地
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white)
                            .shadow(color: .black.opacity(0.08), radius: 8, y:2)
                            .frame(height: 200)
                        
                        VStack {
                            // トプ画像
                            Circle()
                                .frame(width: 50 , height: 50)
                            
                            // ユーザー名
                            Text("氏名")
                            
                            // 各種本の読了・読中など
                            HStack {
                                // 登録冊数
                                VStack {
                                    Text("12")
                                    Text("登録冊数")
                                }
                                
                                // 読了数
                                VStack {
                                    Text("4")
                                    Text("読了数")
                                }
                                
                                // 読中数
                                VStack {
                                    Text("3")
                                    Text("読中")
                                }
                                
                                // 積読数
                                VStack {
                                    Text("5")
                                    Text("積読数")
                                }
                            }
                        }
                    }.padding(16)
                    
                    
                    // プロフィール設定
                    VStack {
                        HStack {
                            Text("プロフィール")
                            Spacer()
                        }
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white)
                            .shadow(color: .black.opacity(0.08), radius: 8, y:2)
                            .frame(height: 150)
                    }.padding(16)
                    
                    
                    // アプリ設定
                    VStack {
                        HStack {
                            Text("アプリ設定")
                            Spacer()
                        }
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white)
                            .shadow(color: .black.opacity(0.08), radius: 8, y:2)
                            .frame(height: 150)
                    }.padding(16)
                    
                    // データ
                    VStack {
                        HStack {
                            Text("データ")
                            Spacer()
                        }
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white)
                            .shadow(color: .black.opacity(0.08), radius: 8, y:2)
                            .frame(height: 150)
                    }.padding(16)
                }
            }
            .navigationTitle("⚙️設定")
            .navigationBarTitleDisplayMode(.inline)
            
        }
        .frame(maxWidth: .infinity,  maxHeight: .infinity)
        .background(Color("AppBackground"))
    }
}

#Preview {
    SettingsView()
}
