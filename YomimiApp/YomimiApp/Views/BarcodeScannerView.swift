//
//  BarcodeScannerView.swift
//  YomimiApp
//
//  Created by 奈宮史典 on 2026/04/06.
//　S-02　スキャン画面

/*
 # 役割
 バーコードを読み取り、本の情報を探しにいく画面（S-02 スキャン）
 ・カメラ部品（ISBNScannerView）から ISBN を受け取る
 ・BookSearchManager に「この ISBN の本を探して」と頼む（自分では API を叩かない）
 ・結果（読み込み中 / 成功 / エラー）を表示し、登録画面（BookRegistrationView）を開く
    ・見つかった ⇨ .scanned ／ 見つからない ⇨ .scanFailed ／ 手動ボタン ⇨ .manual
 
 # 位置
 【フロント側】データの流れの出発点。処理は Managers に任せ、結果を受け取って表示する
 
 Components/ISBNScanner ⇨ Views/⭐️ ⇨ Managers/BookSearchManager ⇨ Services/
 Views/⭐️ ⇦（結果）Managers/BookSearchManager
 Views/⭐️ ⇨ Views/BookRegistrationView
 */

import SwiftUI

struct BarcodeScannerView: View {
    
    @Environment(\.dismiss) var dismiss
    @State private var registrationMode: RegistrationMode?
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
            // スキャン成功時
            .fullScreenCover(item: $registrationMode) { mode in
                BookRegistrationView(mode: mode)
            }
        }
    }
    
    // 検索結果から「どのモードを開くか」で決める
    private func modeAfterSearch()-> RegistrationMode {
        if let summary = bookSearchManager.BookAPISummary {
            return .scanned(summary)
        }
        return .scanFailed
    }
    
    // カメラでISBNを読み取る部分
    private var scannerArea: some View {
        ISBNScannerView { isbn in
            Task {
                await bookSearchManager.search(isbn: isbn)
                registrationMode = modeAfterSearch()
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
        if let BookAPISummary = bookSearchManager.BookAPISummary {
            VStack(alignment: .leading) {
                Text(BookAPISummary.title ?? "タイトル不明")
                Text(BookAPISummary.author ?? "著者不明")
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
            registrationMode = .manual
        } label: {
            Text("手動で入力する")
                .font(.system(size: 14, weight: .bold))
                .foregroundStyle(Color("AccentColor"))
                .frame(width: 150)
                .padding(.vertical, 16)
                .background(Color.white)
                .cornerRadius(12)
        // 手動入力画面へ遷移
        }
    }
    
    // テスト用ボタン
    private var testButton: some View {
        Button("テスト: 仮のISBNで取得") {
            Task {
                await bookSearchManager.search(isbn: "9784163918273") // 正常系センスの哲学のISBN
//                await bookSearchManager.search(isbn: "9784121029164") // 空の想定
//                await bookSearchManager.search(isbn: "19230032804") // 異常系コード
                
                // スキャン成功時に登録画面へ
                registrationMode = modeAfterSearch()
            }
        }
    }
}

#Preview {
    BarcodeScannerView()
}
