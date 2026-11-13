//
//  ContentView.swift
//  YomimiApp
//
//  Created by 奈宮史典 on 2026/04/06.
//

/*
 # 役割
 タブバー（本棚 / お楽しみ / 名刺 / 設定）と、中央のカメラボタンを持つ土台の画面
 ・タブで表示する画面を切り替える
 ・カメラボタンが押されたら、スキャン画面（BarcodeScannerView）を全画面で開く
 ・真ん中の空のタブは、カメラボタンを置くための場所取り
 
 # 位置
 【フロント側】画面の切り替えだけを担当（データの取得・保存はしない）
 
 Views/RootView ⇨ Views/⭐️ ⇨ BookshelfView / BusinessCardView / SettingsView
 Views/⭐️（カメラボタン）⇨ Views/BarcodeScannerView
 */

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
