//
//  BookDetailView.swift
//  YomimiApp
//
//  Created by 奈宮史典 on 2026/04/06.
//　S-05　本詳細

import SwiftUI

struct BookDetailView: View {
    
    let book: BookRecord
        
    var body: some View {
        Text(book.title)
            .font(.title2)
            .navigationTitle("本詳細")
            .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        BookDetailView(book: BookRecord(title: "hogehoge"))
    }
}
