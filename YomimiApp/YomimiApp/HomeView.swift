//
//  ContentView.swift
//  YomimiApp
//
//  Created by 奈宮史典 on 2026/04/06.
//

import SwiftUI

struct HomeView: View {
    
    @State private var showScanner = false  // モーダル管理
    
    var body: some View {
        ZStack(alignment: .bottom) {
            
            // 通常のタブ（カメラは除く）
            TabView {
                
                // 本棚ビュー
                BookshelfView()
                    .tabItem {
                        Label("本棚", systemImage: "books.vertical.fill")
                    }
                
                // 近日公開
                Color.clear
                    .tabItem {
                        Label("お楽しみ", systemImage: "tree.fill")
                    }
                
                // スキャンビュー
                Color.clear
                    .tabItem {
                        Label("", systemImage: "")
                    }
                
                // 名刺ビュー
                BusinessCardView()
                    .tabItem {
                        Label("名刺", systemImage: "person.text.rectangle.fill")
                    }
                
                // 設定ビュー
                SettingsView()
                    .tabItem {
                        Label("設定", systemImage: "gearshape.fill")
                    }
            }
            
            // 中央に浮かせるカメラボタン
            Button {
                showScanner = true
            } label: {
                Image(systemName: "camera.fill")
                    .font(.system(size: 24))
                    .foregroundColor(.white)
                    .frame(width: 60, height: 60)
                    .background(Color("AccentColor"))
                    .clipShape(Circle())
                    .shadow(radius: 4)
            }
        }
        .ignoresSafeArea(.keyboard)
        .fullScreenCover(isPresented: $showScanner) {
            BarcodeScannerView()
        }
    }
}

#Preview {
    HomeView()
}
