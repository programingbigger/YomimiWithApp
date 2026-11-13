//
//  ReadStatusColor.swift
//  YomimiApp
//
//  Created by 奈宮史典 on 2026/10/07.
//

/*
 # 役割
 読書ステータス（ReadStatus）ごとの「色」を決める
 ・Models/ReadStatus に color を後付け（extension）している
 ・色は画面の都合なので、Models ではなく Views 側に置いている
 
 # 位置
 【フロント側】見た目のルール。バッジや絞り込みチップが使う
 
 Models/ReadStatus ⇨ Components/⭐️ ⇨ StatusBadgeView / BookshelfView（チップの色）
 */

import SwiftUI

extension ReadStatus {
    var color: Color {
        switch self {
        case .finished: Color(.statusDone)
        case .reading: Color(.statusReading)
        case .tsundoku: Color(.statusUnread)
        case .toread: Color(.statusToread)
        }
    }
}
