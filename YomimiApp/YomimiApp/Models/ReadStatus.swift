//
//  ReadStatus.swift
//  YomimiApp
//
//  Created by 奈宮史典 on 2026/09/30.
//

/*
 # 役割
 読書ステータス（読了 / 読中 / 積読 / 読みたい）の選択肢を定義する
 ・label で、画面に出す日本語を返す
 ・色（color）はここではなく、Views/Components/ReadStatusColor 側で定義している
 
 # 位置
 【データの型】BookRecord.status の中身。フロント側・処理側の両方から使われる
 
 Models/⭐️ ⇨ BookRecord.status ⇨ Views/（バッジ・絞り込み・登録画面の選択肢）
 */

/*
 aaa = ReadStatus.finished
 status = aaa.label // 読了が出てくる
 */

import Foundation

// ReadStatusのデータモデルを作成
enum ReadStatus: String, Codable, CaseIterable {
    case finished   // 読了
    case reading    // 読中
    case tsundoku   // 積読（未読）
    case toread     // 読みたい本
    
    var label: String {
        switch self {
        case .finished: return "読了"
        case .reading: return "読中"
        case .tsundoku: return "積読" // 積読は定義として説明文をどこかに入れたほうが良さそう・・・読みたいとの違いをちゃんと提示できるように
        case .toread: return "読みたい！"
        }
    }
}
