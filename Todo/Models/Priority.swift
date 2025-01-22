//
//  Priority.swift
//  Todo
//
//  Created by 최시온 on 1/22/25.
//

import Foundation

enum Priority: Int, Codable, CaseIterable {
    case low = 1
    case medium = 2
    case high = 3
    
    var title: String {
        switch self {
        case .low: return "Low"
        case .medium: return "Medium"
        case .high: return "High"
        }
    }
}
