//
//  StarRatingView.swift
//  YomimiApp
//
//  Created by 奈宮史典 on 2026/10/07.
//

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
