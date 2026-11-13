//
//  BookCoverView.swift
//  YomimiApp
//
//  Created by 奈宮史典 on 2026/10/07.
//

/*
 # 役割
 本の表紙（書影）を表示する部品
 ・書影の URL があれば、その画像を読み込んで表示する（読み込みは AsyncImage が自動で行う）
 ・URL が無い / 読み込めないときは、タイトルを書いた仮の表紙を表示する
 
 # 位置
 【フロント側】いろいろな画面から呼ばれる部品。渡された値を表示するだけ
 
 BookshelfView / SelectBookView / BookDetailView / BookRegistrationView ⇨ Components/⭐️
 */

import SwiftUI

struct BookCoverView: View {
    let title: String
    let thumbnailURL: String?
    var width: CGFloat = 100
    var height: CGFloat = 150
    
    private var url: URL? {
        guard let s = thumbnailURL, !s.isEmpty else { return nil }
        return URL(string: s)
    }
    
    // URLが取得できなかった時ようの表紙View
    private var placeholder:some View {
        ZStack {
            RoundedRectangle(cornerRadius: 6).fill(Color(.appSurface))
            RoundedRectangle(cornerRadius: 6).stroke(Color.secondary.opacity(0.3))
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .lineLimit(4)
                .padding(8)
        }
    }
    
    var body: some View {
        Group {
            if let url {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let image):
                        image.resizable().scaledToFill()
                    default:
                        placeholder
                    }
                }
            } else {
                placeholder
            }
        }
        .frame(width: width, height: height)
        .clipShape(RoundedRectangle(cornerRadius: 6))
    }
}
