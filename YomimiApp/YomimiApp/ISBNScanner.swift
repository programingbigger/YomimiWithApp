//
//  ISBNScanner.swift
//  YomimiApp
//
//  Created by 奈宮史典 on 2026/09/01.
//

import SwiftUI
import AVFoundation

// １「検出したら、誰にどう伝えるか」というプロトコル（契約）を定義する
protocol ScannerViewControllerDelegate: AnyObject { // プロトコルの設定
    func didScan(isbn: String)
}

// ２　実際にカメラを制御し、１のルールに従ってdelegateへ伝える本体（UIKit側）
final class ScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    weak var delegate: ScannerViewControllerDelegate? // ScannerViewControllerDelegateというプロトコルのプロトコル指定（⇨型指定）
    private let session = AVCaptureSession()
    private var didFireOnce = false // 連続検出で何度もコールバックされるのを防ぐ
    
    override func viewDidLoad() {
        super.viewDidLoad()
        #if DEBUG
        print("🟨 [viewDidLoad] 画面がロードされました。setupSession()を呼びます")
        #endif
        setupSession()
    }
    
    private func setupSession() {
        #if DEBUG
        print("🟨 [setupSession] 開始")
        #endif
        
        // inputとデバイスの定義
        guard let device = AVCaptureDevice.default(for: .video),
              let input = try? AVCaptureDeviceInput(device: device) else {
            #if DEBUG
            print("🟥 [setupSession] カメラデバイス or 入力の取得に失敗。ここで終了します")
            #endif
            return
        }
        
        #if DEBUG
        print("🟨 [setupSession] カメラデバイス取得成功: \(device.localizedName)")
        #endif
        
        // 入力
        if session.canAddInput(input) {
            session.addInput(input)
            #if DEBUG
            print("🟨 [setupSession] inputをsessionに追加しました")
            #endif
        } else {
            #if DEBUG
            print("🟥 [setupSession] inputをsessionに追加できませんでした")
            #endif
        }
        
        // 出力の定義
        let output = AVCaptureMetadataOutput()
        if session.canAddOutput(output) {
            session.addOutput(output)
            output.setMetadataObjectsDelegate(self, queue: .main)
            output.metadataObjectTypes = [.ean13, .ean8]
            #if DEBUG
            print("🟨 [setupSession] outputをsessionに追加し、delegateとして自分自身を登録しました（EAN-13/EAN-8を監視）")
            #endif
        } else {
            #if DEBUG
            print("🟥 [setupSession] outputをsessionに追加できませんでした")
            #endif
        }
        
        // 映すカメラの枠の設定
        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.frame = view.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        #if DEBUG
        print("🟨 [setupSession] previewLayerを画面に追加しました")
        #endif
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            #if DEBUG
            print("🟧 [setupSession] バックグラウンドスレッドでsession.startRunning()を呼び出します")
            #endif
            self?.session.startRunning()
            #if DEBUG
            print("🟧 [setupSession] session.startRunning()が完了。isRunning=\(self?.session.isRunning ?? false)")
            #endif
        }
    }
    
    // カメラがバーコードらしきものを検出するたびに、AVFoundationが自動で呼び出す
    func metadataOutput(_ output: AVCaptureMetadataOutput
                        , didOutput metadataObjects: [AVMetadataObject]
                        , from connection: AVCaptureConnection) {
        guard !didFireOnce else {return} // すでに検出済みならば以降は無視（ログが大量に流れるので、コメントは省略）
        
        guard let object = metadataObjects.first as? AVMetadataMachineReadableCodeObject else {
            return
        }
        
        guard let isbn = object.stringValue else {
            #if DEBUG
            print("🟥 [metadataOutput] バーコードは検出したが、stringValueの取得に失敗")
            #endif
            return
        }
        
        didFireOnce = true
        session.stopRunning()
        #if DEBUG
        print("🟩 [metadataOutput] ISBN検出成功: \(isbn) → カメラを停止し、delegateへ通知します")
        #endif
        delegate?.didScan(isbn: isbn) // 1の契約通りに、delegata(Coordinator)へ報告。このdidScanは、
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if session.isRunning {
            session.stopRunning()
            #if DEBUG
            print("🟨 [viewWillDisappear] 画面が閉じるのでカメラを停止しました")
            #endif
        }
    }
    
}

// 3 ２からの報告を受け取り、SwiftUI側へ橋渡しする窓口
// SwiftUIからカメラ画面を使うためのラッパー
struct ISBNScannerView: UIViewControllerRepresentable {
    // スキャンに成功したときに呼ばれる（ISBNの文字列を返す）
    var onScanned: (String) -> Void
    
    func makeUIViewController(context: Context) -> ScannerViewController {
        let vc = ScannerViewController()
        vc.delegate = context.coordinator // ルールを守ったらなんでも入れていい箱
        #if DEBUG
        print("🟦 [makeUIViewController] ScannerViewControllerを生成し、delegateにCoordinatorをセットしました")
        #endif
        return vc
    }
    
    func updateUIViewController(_ uiViewController: ScannerViewController, context: Context) {}
    
    // レシピに則ってCoordinatorを作成する
    func makeCoordinator() -> Coordinator {
        #if DEBUG
        print("🟦 [makeCoordinator] Coordinatorを生成しました") // ここで勝手にSwiftUI側が勝手に保存をしてくれる
        #endif
        return Coordinator(onScanned: onScanned)
    }
    
    // Coodinatorの定義
    // １の契約（ScannerViewControllerDelegate）を守り、検出結果をonScannedクロージャへ渡す伝言役
    // これは、「Coordinatorとはどういうものか」の設計図（レシピ）
    final class Coordinator: NSObject, ScannerViewControllerDelegate { // NSObjectでなおかつ契約１を守っているもの
        let onScanned: (String) -> Void
        init(onScanned: @escaping (String) -> Void) {
            self.onScanned = onScanned
        }
        
        func didScan(isbn: String) {
            #if DEBUG
            print("🟩 [Coordinator.didScan] 受け取ったISBN: \(isbn) → onScannedクロージャを呼びます")
            #endif
            onScanned(isbn) //
        }
    }
}
