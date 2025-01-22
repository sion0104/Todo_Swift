//
//  TodoListView.swift
//  Todo
//
//  Created by 최시온 on 1/22/25.
//
import SwiftUI
import SwiftData


struct TodoListView: View {
    @Environment(\.modelContext) private var modelContext
    
    @Query private var todos: [TodoItem]

    @State private var sortOption: SortOption = .byDateAscending

    
    let searchText: String
    let selectedPriority: Priority?
    
    var filteredAndSortedTodos: [TodoItem] {
        var result = todos
        
        if !searchText.isEmpty {
            result = result.filter {
                $0.title.lowercased().contains(searchText.lowercased())
            }
        }
        
        if let selectedPriority = selectedPriority {
            result = result.filter { $0.priority == selectedPriority }
        }
        
        switch sortOption {
        case .byDateAscending:
            result = result.sorted { ($0.dueDate ?? .distantFuture ) < ($1.dueDate ?? .distantFuture) }
        case .byDateDescending:
            result = result.sorted { ($0.dueDate ?? .distantFuture ) > ($1.dueDate ?? .distantFuture) }
        case .byPriority:
            result = result.sorted { ($0.priority?.rawValue ?? 0) < ($1.priority?.rawValue ?? 0) }
        case .byTitle:
            result = result.sorted { $0.title.lowercased() < $1.title.lowercased() }
        }
        
        return result
    }
    
    var body: some View {
        List {
            ForEach(filteredAndSortedTodos) { todo in
                TodoRowView(todo: todo)
            }
            .onDelete(perform: deleteTodo)
        }
    }
    
    private func deleteTodo(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(todos[index])
            }
            saveChanges()
        }
    }
    
    private func saveChanges() {
        do {
            try modelContext.save()
        } catch {
            print("Error saving changes: \(error.localizedDescription)")
        }
    }
}
