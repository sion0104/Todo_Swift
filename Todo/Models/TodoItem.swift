//
//  Item.swift
//  Todo
//
//  Created by 최시온 on 1/17/25.
//

import Foundation
import SwiftData

@Model
final class TodoItem: Identifiable {
    @Attribute(.unique) var id = UUID()
    var title: String
    var isCompleted: Bool
    var priority: Priority?
    var dueDate: Date?
    var isCreated: Date
    
    init(id: UUID = UUID(), title: String, isCompleted: Bool = false, priority: Priority? = nil, dueDate: Date? = nil, isCreated: Date = Date()) {
        self.id = id
        self.title = title
        self.isCompleted = isCompleted
        self.priority = priority
        self.dueDate = dueDate
        self.isCreated = isCreated
    }
}

