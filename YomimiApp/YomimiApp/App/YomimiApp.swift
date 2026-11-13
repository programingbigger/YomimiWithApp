//
//  YomimiAppApp.swift
//  YomimiApp
//
//  Created by 奈宮史典 on 2026/04/06.
//

/*
 # 役割
 アプリの入口（起動したら最初に動く場所）
 ・最初に表示する画面として RootView を指定する
 ・SwiftData の保存場所（modelContainer）を用意し、どの画面からも BookRecord を読み書きできるようにする
 
 # 位置
 【土台】フロント側でも処理側でもなく、両方が動くための準備をする場所
 
 App/⭐️ ⇨ Views/RootView ⇨ Views/HomeView ⇨ 各画面
 */

import SwiftUI
import SwiftData

@main
struct YomimiApp: App {
    var body: some Scene {
        WindowGroup {
            RootView()
        }
        .modelContainer(for:BookRecord.self)
    }
    
}
