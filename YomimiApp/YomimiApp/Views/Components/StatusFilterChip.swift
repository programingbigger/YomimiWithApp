//
//  StatusFilterChip.swift
//  YomimiApp
//
//  Created by 奈宮史典 on 2026/10/07.
//

/*
 # 役割
 本棚の絞り込みに使うチップ（「すべて 12」「読了 4」のようなボタン）
 ・タイトル / 冊数 / 色 / 選択中かどうか を受け取って表示する
 ・押されたときに何をするか（action）は、呼び出し元から渡してもらう
 
 # 位置
 【フロント側】部品。絞り込みそのものは呼び出し元（BookshelfView）が行う
 
 Views/BookshelfView ⇨ Components/⭐️
 */

import SwiftUI

struct StatusFilterChip: View {
    let title: String
    let count: Int
    let color: Color?
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 4) {
                if let color {
                    Circle()
                        .fill(color)
                        .frame(width: 6, height: 6)
                }
                Text("\(title) \(count)")
                    .font(.caption)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .foregroundStyle(isSelected ? Color.white : Color.primary)
            .background(isSelected ? Color(.accentPrimary) : Color(.appSurface))
            .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }
}
