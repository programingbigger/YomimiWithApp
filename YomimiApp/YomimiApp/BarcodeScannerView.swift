//
//  BarcodeScannerView.swift
//  YomimiApp
//
//  Created by 奈宮史典 on 2026/04/06.
//　S-02　スキャン画面

import SwiftUI

struct BarcodeScannerView: View {
    
    @Environment(\.dismiss) var dismiss
    @State var isShowingBookRegistrationView = false
    
    var body: some View {
        NavigationStack{
            VStack(alignment: .center) {
                
                // スキャン場所
                Capsule()
                    .frame(width: 300, height: 400)
                
                // 手動入力
                Button {
                    isShowingBookRegistrationView = true
                } label: {
                    Text("手動で入力する")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(Color("AccentColor"))
                        .frame(width: 150)
                        .padding(.vertical, 16)
                        .background(Color.white)
                        .cornerRadius(12)
                }.fullScreenCover(isPresented: $isShowingBookRegistrationView) {
                    BookRegistrationView() // 手動入力画面へ遷移
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
                        Label("× 閉じる", image: "xmark")
                    }
                }
            }
        }
    }
}

#Preview {
    BarcodeScannerView()
}
