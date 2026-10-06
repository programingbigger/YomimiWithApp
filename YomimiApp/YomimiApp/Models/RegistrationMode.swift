//
//  RegistrationMode.swift
//  YomimiApp
//
//  Created by 奈宮史典 on 2026/10/06.
//

/*

・BarcodeScannerView.swiftの遷移先のモデルを定義する
・定義するのは以下の通り
    ・スキャン成功
    ・スキャン失敗（）
    ・手動入力（ユーザー自身の選択による）
        ・なぜ必要か？
            ・バーコードが読み取れない時
            ・本にバーコードそのものが存在しない時（ex: 雑誌・ISBNが導入される前の本）
            ・本が手元にない時（例えば、友人からおすすめされた本を登録したい・・・など、> 手動で入力する）
 */

import Foundation

enum RegistrationMode: Identifiable {
    case scanned(BookAPISummary) // 成功：本の読み取りが成功した
    case scanFailed              // 失敗：タイトル入力画面へ
    case manual                  // 手動ボタンから：最初から入力
    
    // fullScreenCover(item: )が「どのモードか」を見分けるための目標
    var id: String {
        switch self {
        case .scanned: "scanned"
        case .scanFailed: "scanFailed"
        case .manual: "manual"
        }
    }
    
    // .scannedの時だけ本の情報を取り出す
    var summary: BookAPISummary? {
        if case .scanned(let bookAPISummary) = self { return bookAPISummary }
        return nil
    }
}
