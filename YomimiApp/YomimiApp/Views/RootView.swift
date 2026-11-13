//
//  rootCView.swift
//  YomimiApp
//
//  Created by 奈宮史典 on 2026/11/12.
//

/*
 # 役割
 全画面の一番外側の枠
 ・設定画面で切り替えた「ダークモード（isDarkMode）」を読み取り、アプリ全体の見た目に反映する
 ・中身として HomeView を表示する
 
 # 位置
 【フロント側】見た目だけを扱う（データの取得・保存はしない）
 
 App/YomimiApp ⇨ Views/⭐️ ⇨ Views/HomeView
 Views/SettingsView（トグル）⇨ isDarkMode ⇨ Views/⭐️（受け取って反映）
 */

import SwiftUI

struct RootView: View {
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    var body: some View {
        HomeView()
            .preferredColorScheme(isDarkMode ? .dark : .light)
    }
}
