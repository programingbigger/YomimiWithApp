//
//  YomimiAppApp.swift
//  YomimiApp
//
//  Created by 奈宮史典 on 2026/04/06.
//

import SwiftUI
import SwiftData

@main
struct YomimiApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView()
        }
        .modelContainer(for:BookRecord.self)
    }
}
