//
//  BarcodeScannerView.swift
//  YomimiApp
//
//  Created by 奈宮史典 on 2026/04/06.
//　S-02　スキャン画面

import SwiftUI

struct BarcodeScannerView: View {
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack{
            VStack(alignment: .center) {
                
                // スキャン場所
                Capsule()
                    .frame(width: 300, height: 400)
                
                // 手動入力
                Button {
                    
                } label: {
                    Text("手動で入力する")
                }
                
                Spacer()

            }
            .navigationTitle("バーコードをスキャン")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Label("閉じる", image: "xmark")
                    }
                }
            }
        }

    }
}

#Preview {
    BarcodeScannerView()
}
