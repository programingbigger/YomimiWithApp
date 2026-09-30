//
//  ReadStatus.swift
//  YomimiApp
//
//  Created by 奈宮史典 on 2026/09/30.
//

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
