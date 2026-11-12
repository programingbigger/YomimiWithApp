//
//  YomimiAppApp.swift
//  YomimiApp
//
//  Created by 奈宮史典 on 2026/04/06.
//

/*
 # 補足
 ・ダークモード / ライトモードの切り替え
    ・preferredColorSchemeを使用しない理由
    ・「設定は切り替わっているのに、SwiftUI の preferredColorScheme がダーク→ライトの画面更新に失敗する、既知の不具合の疑いがある。
 ・対応
    ・ウィンドウ全体の外観を直接切り替える関数を作成し、トグルのたびに「isDarkMode」フラグが変わるよにする
 
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
