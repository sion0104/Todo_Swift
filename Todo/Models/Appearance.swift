//
//  Appearance.swift
//  Todo
//
//  Created by 최시온 on 1/21/25.
//

import Foundation

enum Appearance: String, CaseIterable, Identifiable {
    case system
    case light
    case dark

    var id: String { self.rawValue }
    
    var colorScheme: ColorScheme? {
        switch self {
        case .system: return nil
        case .light: return .light
        case .dark: return .dark
        }
    }
}
