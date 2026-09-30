//
//  BarcodeScannerView.swift
//  YomimiApp
//
//  Created by 奈宮史典 on 2026/04/06.
//　S-02　スキャン画面

import SwiftUI

struct BarcodeScannerView: View {
    
    @Environment(\.dismiss) var dismiss
    @State private var isShowingBookRegistrationView = false // 本の登録画面への遷移
    @State private var bookSearchManager = BookSearchManager() // バーコードからAPIを検索するクラス
    
    var body: some View {
        NavigationStack{
            VStack(alignment: .center) {
                
                // カメラでISBNを読み取る部分
                scannerArea
                
                // 取得結果を表示する部分
                resultArea
                
                // 手動入力ボタン
                manualInputButton
                
                // テスト用ボタン
                #if DEBUG
                testButton
                #endif
                
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
    
    // カメラでISBNを読み取る部分
    private var scannerArea: some View {
        ISBNScannerView { isbn in
            Task {
                await bookSearchManager.search(isbn: isbn)
            }
        }
        .frame(width: 300, height: 300)
    }
    
    // 取得結果を表示する部分
    @ViewBuilder // 表示するViewが4つあるが、それらをViewをまとめて1つにするため
    private var resultArea: some View {
        if let scannerISBM = bookSearchManager.scannedISBN {
            Text("取得したISBN: \(scannerISBM)")
        }
        if bookSearchManager.isLoading {
            ProgressView()
        }
        if let bookSummary = bookSearchManager.bookSummary {
            VStack(alignment: .leading) {
                Text(bookSummary.title ?? "タイトル不明")
                Text(bookSummary.author ?? "著者不明")
            }
        }
        if let errorMessage = bookSearchManager.errorMessage {
            Text(errorMessage)
                .foregroundStyle(.red)
        }
    }
    
    // 手動入力ボタン
    private var manualInputButton: some View {
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
    }
    
    // テスト用ボタン
    private var testButton: some View {
        Button("テスト: 仮のISBNで取得") {
            Task {
                await bookSearchManager.search(isbn: "9784163918273") // センスの哲学のISBN
            }
        }
    }
    
}

#Preview {
    BarcodeScannerView()
}
