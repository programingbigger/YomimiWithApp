//
//  StatusBadgeView.swift
//  YomimiApp
//
//  Created by 奈宮史典 on 2026/10/07.
//

import SwiftUI

struct StatusBadgeView: View {
    let status: ReadStatus
    
    private var color: Color {
        switch status {
        case .finished: Color(.statusDone)
        case .reading: Color(.statusReading)
        case .tsundoku: Color(.statusUnread)
        case .toread: Color(.statusToread)
        }
    }
    
    var body: some View {
        HStack(spacing: 4) {
            Circle()
                .fill(color)
                .frame(width: 6, height: 6)
            Text(status.label)
                .font(.caption2)
                .foregroundStyle(color)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 3)
        .background(color.opacity(0.15))
        .clipShape(Capsule())
    }
}

#Preview {
    VStack(alignment: .leading) {
        ForEach(ReadStatus.allCases, id: \.self) { StatusBadgeView(status: $0) }
    }
}
