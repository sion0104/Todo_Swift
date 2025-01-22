//
//  TodoRowView.swift
//  Todo
//
//  Created by 최시온 on 1/22/25.
//

import SwiftUI

struct TodoRowView: View{
    let todo: TodoItem

    @State private var isShowingEditView = false

    
    var body: some View {
        HStack (spacing: 12) {
                Image(systemName: todo.isCompleted ? "checkmark.circle.fill": "circle")
                    .font(.title2)
                    .foregroundStyle(todo.isCompleted ? .green : .gray)
            
            
            
            VStack(alignment: .leading, spacing: 4) {
                Text(todo.title)
                    .font(.headline)
                    .foregroundStyle(todo.isCompleted ? .gray : .primary)
                    .strikethrough(todo.isCompleted, color: .gray)
                
                if let dueText = remainingTime(for: todo.dueDate) {
                    Text(dueText)
                        .foregroundStyle(.gray)
                        .font(.caption)
                }
            }
            Spacer()
            
            Image(systemName: icon(for: todo.priority))
                .font(.title2)
                .foregroundStyle(color(for: todo.priority))
        }
        .onTapGesture {
            todo.isCompleted.toggle()
        }
        .onLongPressGesture {
            isShowingEditView = true
        }
        .sheet(isPresented: $isShowingEditView) {
            NavigationStack {
                EditTodoView(todo: todo)
            }
        }
        
    }
    
    private func remainingTime(for dueDate: Date?) -> String? {
        
        let calendar = Calendar.current
        let currentDate = Date()
        
        guard let dueDate = dueDate else {
            return nil
        }
        
        if dueDate < currentDate {
            return "기한 초과"
        }
        
        let components = calendar.dateComponents([.day, .hour, .minute], from: currentDate, to: dueDate)
        
        if let day = components.day, day > 0 {
            return "\(day)일 남음"
        } else if let hour = components.hour, hour > 0 {
            return "\(hour)시간 남음"
        } else if let minute = components.minute, minute > 0 {
            return "\(minute)분 남음"
        } else {
            return "기한 임박"
        }
    }
    
    
    private func icon(for priority: Priority?) -> String {
        switch priority {
        case .high:
            return "arrowshape.up.circle.fill"
        case .medium:
            return "minus.circle.fill"
        case .low:
            return "arrowshape.down.circle.fill"
        default:
            return ""
        }
    }

    private func color(for priority: Priority?) -> Color {
        switch priority {
        case .high:
            return .red
        case .medium:
            return .orange
        case .low:
            return .green
        default:
            return .clear
        }
    }
}

#Preview {
    ScrollView
    {
        VStack {
            TodoRowView(todo: TodoItem(title: "first", isCompleted: false, priority: .high))
                .modelContainer(for: TodoItem.self, inMemory: true)
        }
    }
}
