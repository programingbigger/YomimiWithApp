//
//  ReadStatusColor.swift
//  YomimiApp
//
//  Created by 奈宮史典 on 2026/10/07.
//

import SwiftUI

extension ReadStatus {
    var color: Color {
        switch self {
        case .finished: Color(.statusDone)
        case .reading: Color(.statusReading)
        case .tsundoku: Color(.statusUnread)
        case .toread: Color(.statusToread)
        }
    }
}
