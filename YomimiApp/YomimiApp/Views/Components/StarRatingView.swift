//
//  StarRatingView.swift
//  YomimiApp
//
//  Created by 奈宮史典 on 2026/10/07.
//

/*
 # 役割
 おすすめ度を星（1〜5）で表示・入力する部品
 ・星をタップすると、呼び出し元の rating を書き換える（@Binding）
 ・同じ星をもう一度タップすると解除（nil）になる
 
 # 位置
 【フロント側】部品。値を保存するのは呼び出し元（BookDetailView）の仕事
 
 Views/BookDetailView ⇔ Components/⭐️
 */

/*
 おすすめ度の星評価をつけるView
 */

import SwiftUI

struct StarRatingView: View {
    @Binding var rating: Int?
    
    var body: some View {
        HStack(spacing: 6) {
            ForEach(1...5, id: \.self) { star in
                Image(systemName: star <= (rating ?? 0) ? "star.fill" : "star")
                    .font(.title3)
                    .foregroundStyle(star <= (rating ?? 0) ? Color(.accentMid) : Color(.appBorder))
                    .onTapGesture {
                        // 同じ量をもう一度タップしたら解除
                        if rating == star {
                            rating = nil
                        } else {
                            rating = star
                        }
                    }
            }
        }
    }
}

#Preview {
    @Previewable @State var rating: Int? = 3
    StarRatingView(rating: $rating)
}
