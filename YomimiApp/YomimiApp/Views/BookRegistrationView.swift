//
//  BookManualRegisterView.swift
//  YomimiApp
//
//  Created by 奈宮史典 on 2026/04/06.
//　S-04　手動登録

import SwiftUI

// 既存のRegistrationModeを拡張する形で、スキャン成功後のバナー表示の規格を設定（modeは画面に影響されてはいけない設計のため、このように記載）
private extension RegistrationMode {
    var bannerColor: Color {
        switch self {
        case .scanned, .manual: .green
        case .scanFailed: .red
        }
    }
    
    var bannerIcon: String {
        switch self {
        case .scanned: "checkmark.circle.fill"
        case .scanFailed: "exclamationmark.triangle.fill"
        case .manual: "square.and.pencil"
        }
    }
    
    var bannerMessage: String {
        switch self {
        case .scanned:    "スキャンに成功しました！\n内容を確認して、本棚に登録しましょう"
        case .scanFailed: "スキャンできませんでした。\nタイトルを入力して登録しましょう"
        case .manual:     "手動で入力します。\nわかる範囲で入力してください"
        }
    }
}

// 登録画面本体
struct BookRegistrationView: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext
    @State private var manager = BookRegistrationManager()
    
    // フォーム入力値（スキャン成功時は init でプリフィル）
    @State private var title: String
    @State private var author: String
    @State private var publisher: String
    @State private var publishedDate: String
    @State private var genre: String = "" // ジャンル
    @State private var pageCountText: String = ""
    @State private var status: ReadStatus = .tsundoku // 初期値は積読
    @State private var finishedDate: Date = .now // 読了日
    
    // 書籍登録モード：BookRegistrationViewの引数
    let mode: RegistrationMode
    
    init(mode: RegistrationMode) {
        self.mode = mode
        _title = State(initialValue:  mode.summary?.title ?? "")
        _author = State(initialValue:  mode.summary?.author ?? "")
        _publisher = State(initialValue:  mode.summary?.publisher ?? "")
        _publishedDate = State(initialValue:  mode.summary?.pubdate ?? "")
        
    }
    
    
    var body: some View {
        NavigationStack() {
            
            ScrollView {
                
                Divider()
                
                
                VStack {
                    
                    // スキャン結果に応じたバナーを表示
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(mode.bannerColor)
                            .opacity(0.2)
                            .frame(height: 80)
                        HStack {
                            Image(systemName: mode.bannerIcon)
                                .font(.system(size: 28))
                                .foregroundStyle(mode.bannerColor)
                                .frame(width: 50, height: 50)
                            Text(mode.bannerMessage)
                                .font(.subheadline)
                        }
                        .padding(.horizontal, 16)
                    }
                    .padding(16)
                    
                    // 本の表紙など
                    HStack() {
                        Capsule()
                            .frame(width: 100, height: 150)
                        
                        VStack(alignment: .leading) {
                            Text("本のタイトル")
                                .font(.title3)
                            Text("著者 / 出版社 / 出版日")
                            Capsule()
                                .frame(width: 150, height: 20)
                        }
                    }
                    .padding(16)
                    
                    // 必須項目
                    VStack {
                        HStack {
                            Text("必須項目")
                            Spacer()
                        }
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.white)
                                .shadow(color: .black.opacity(0.08), radius: 8, y:2)
                                .frame(height: 150)
                            VStack {
                                TextField("タイトル", text: $title)
                                TextField("著者名", text: $author)
                            }
                            .padding(16)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.white)
                                    .shadow(color: .black.opacity(0.08), radius: 8, y: 2)
                            )
                        }
                    }
                    .padding(16)
                    
                    
                    // 任意項目
                    VStack {
                        HStack {
                            Text("任意項目")
                            Spacer()
                        }
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.white)
                                .shadow(color: .black.opacity(0.08), radius: 8, y:2)
                                .frame(height: 150)
                            VStack {
                                TextField("出版社", text: $publisher)
                                TextField("ジャンル", text: $genre)
                                TextField("ページ数", text: $pageCountText)
                                    .keyboardType(.numberPad)
                                TextField("出版年月", text: $publishedDate)
//                                Text("感想や気づきを入力")
//                                Text("オススメ度") // 星 or 小数点第2位くらいまで入力できるような形へ
                            }
                            .padding(16)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.white)
                                    .shadow(color: .black.opacity(0.08), radius: 8, y: 2)
                            )
                        }
                    }
                    .padding(16)
                    
                    // 読書ステータス
                    
                    VStack {
                        HStack {
                            Text("📖 読書ステータス")
                            Spacer()
                        }
                        VStack(spacing: 12) {
                            Picker("ステータス", selection: $status) {
                                ForEach(ReadStatus.allCases, id: \.self) { s in
                                    Text(s.label).tag(s)
                                }
                            }
                            
                            // 読了の時だけ表示
                            if status == .finished {
                                DatePicker("読了日", selection: $finishedDate, displayedComponents: .date)
                            }
                        }
                        .padding(16)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.white)
                                .shadow(color: .black.opacity(0.08), radius: 8, y: 2)
                        )
                    }
                    .padding(16)
                    
                    // 本の情報 手動登録ボタン
                    Button {
                        let book = BookRecord(
                            isbn: mode.summary?.isbn,
                            title: title,
                            author: author,
                            publisher: publisher.isEmpty ? nil : publisher,
                            publishedDate: publishedDate.isEmpty ? nil : publishedDate,
                            genre: genre.isEmpty ? nil : genre,
                            thumbnailURL: mode.summary?.coverURL,
                            status: status,
                            finishedDate: status == .finished ? finishedDate : nil,
                            pageCount: Int(pageCountText)
                        )
                        if manager.register(book, in: modelContext) {
                            dismiss()
                        }
                    } label: {
                        Text("📚本棚に登録する")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundStyle(.white)
                            .frame(width: 150)
                            .padding(.vertical, 16)
                            .background(Color("AccentColor"))
                            .cornerRadius(12)
                    }
                    
                    // 失敗した時の文言
                    if let message = manager.errorMessage {
                        Text(message)
                            .foregroundStyle(.red)
                            .padding(.top, 8)
                    }
                }
            }
            .navigationTitle("本を手動で登録")
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
        .frame(maxWidth: .infinity,  maxHeight: .infinity)
        .background(Color("AppBackground"))
        
        #if DEBUG
        .onAppear{ // 画面に一回だけ現れるやつ
            print("🟠 [BookRegistrationView] 受け取り: success=\(mode.id), title=\(mode.summary?.title ?? "nil")")
        }
        #endif
    }
}


#Preview {
    BookRegistrationView(mode: .manual)
}
