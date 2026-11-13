//
//  StatusBadgeView.swift
//  YomimiApp
//
//  Created by 奈宮史典 on 2026/10/07.
//

/*
 # 役割
 読書ステータスを「色付きの丸 ＋ 文字」のバッジで表示する部品
 ・文言は ReadStatus.label、色は ReadStatus.color（ReadStatusColor）を使う
 
 # 位置
 【フロント側】部品。渡されたステータスを表示するだけ
 
 BookshelfView / SelectBookView / BookDetailView ⇨ Components/⭐️
 */

import SwiftUI

struct StatusBadgeView: View {
    let status: ReadStatus
    
    var body: some View {
        HStack(spacing: 4) {
            Circle()
                .fill(status.color)
                .frame(width: 6, height: 6)
            Text(status.label)
                .font(.caption2)
                .foregroundStyle(status.color)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 3)
        .background(status.color.opacity(0.15))
        .clipShape(Capsule())
    }
}

#Preview {
    VStack(alignment: .leading) {
        ForEach(ReadStatus.allCases, id: \.self) { StatusBadgeView(status: $0) }
    }
}
