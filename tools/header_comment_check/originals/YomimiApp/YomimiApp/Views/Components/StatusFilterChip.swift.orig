//
//  StatusFilterChip.swift
//  YomimiApp
//
//  Created by 奈宮史典 on 2026/10/07.
//

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
