//
//  rootCView.swift
//  YomimiApp
//
//  Created by 奈宮史典 on 2026/11/12.
//

import SwiftUI

struct RootView: View {
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    var body: some View {
        HomeView()
            .preferredColorScheme(isDarkMode ? .dark : .light)
    }
}
