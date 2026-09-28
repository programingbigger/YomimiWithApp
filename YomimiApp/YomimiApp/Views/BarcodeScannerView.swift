//
//  BarcodeScannerView.swift
//  YomimiApp
//
//  Created by 奈宮史典 on 2026/04/06.
//　S-02　スキャン画面

import SwiftUI

struct BarcodeScannerView: View {
    
    @Environment(\.dismiss) var dismiss
    @State var isShowingBookRegistrationView = false // 本の登録画面への遷移
    @State var scannedISBN: String?
    @State var bookSummary: BookSummary?
    @State var isLoading = false
    @State var errorMessage: String?
    
    let bookAPIService: BookAPIService = OpenBDService()
    
    var body: some View {
        NavigationStack{
            VStack(alignment: .center) {
                
                // スキャン場所
                ISBNScannerView { isbn in
                    scannedISBN = isbn
                    Task {
                        isLoading = true
                        do {
                            bookSummary = try await bookAPIService.fetchBookInfo(isbn: isbn)
                        } catch {
                            errorMessage = "取得に失敗しました: \(error)"
                        }
                        isLoading = false
                    }
                    
                }
                .frame(width: 300, height: 300)
                
                if let scannedISBN {
                    Text("取得したISBN: \(scannedISBN)")
                }
                
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
                
                // テスト用
                Button("テスト: 仮のISBNで取得") {
                    Task {
                        isLoading = true
                        do {
                            bookSummary = try await bookAPIService.fetchBookInfo(isbn: "9784163918273")
                        } catch {
                            errorMessage = "取得に失敗しました: \(error)"
                        }
                        isLoading = false
                    }
                }
                
                if isLoading {
                    ProgressView()
                }
                if let bookSummary {
                    VStack(alignment: .leading) {
                        Text(bookSummary.title ?? "タイトル不明")
                        Text(bookSummary.author ?? "著者不明")
                    }
                }
                if let errorMessage {
                    Text(errorMessage).foregroundStyle(.red)
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
