//
//  ContentView.swift
//  Todo
//
//  Created by 최시온 on 1/17/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var todos: [TodoItem]
    @State private var isAddingTodo = false
    @State private var searchText: String = ""
    @State private var isSearching = false
    @State private var sortByDate = false
    @State private var selectedPriority: String? = nil
    

    var filteredTodos: [TodoItem] {
        var result = todos
        if !searchText.isEmpty {
                   result = result.filter{
                       $0.title.lowercased().contains(searchText.lowercased())
           }
       }
       
       if let selectedPriority = selectedPriority {
           result = result.filter { $0.priority == selectedPriority }
       }
       return result
        
    }

    var sortedTodos: [TodoItem] {
        if sortByDate {
            return filteredTodos.sorted { $0.dueDate < $1.dueDate}
        }
        return filteredTodos
    }
    

    var body: some View {
        NavigationStack {
            VStack (spacing: 0){
                if isSearching {
                    HStack {
                        TextField("Search", text: $searchText)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                        
                        Button("Cancel") {
                            withAnimation {
                                isSearching = false
                                searchText = ""
                            }
                        }
                        .padding(.trailing)
                        
                    }
                    .background(Color(.systemGray6))
                }
                
                List {
                    ForEach(sortedTodos) { todo in
                            HStack {
                                Button {
                                    toggleCompletion(for: todo)
                                } label: {
                                    Image(systemName: todo.isCompleted ? "checkmark.circle.fill": "circle")
                                        .foregroundStyle(todo.isCompleted ? .green : .gray)
                                }
                                .buttonStyle(PlainButtonStyle())
                                
                                NavigationLink {
                                    TodoDetailView(todo: todo)
                                } label: {
                                    Text(todo.title)
                                        .strikethrough(todo.isCompleted, color: .gray)
                                        .foregroundStyle(todo.isCompleted ? .gray : .primary)
                                }
                                Spacer()
                                
                                Text(remainingTime(for: todo.dueDate))
                                    .foregroundStyle(.gray)
                                    .font(.footnote)
                            }
                        
                    }
                    .onDelete(perform: deleteTodo)
                }
                .navigationTitle("Todo List")
                .toolbar {
                    ToolbarItem {
                        Button(action: {
                            isAddingTodo = true
                        }) {
                            Label("Add Item", systemImage: "plus")
                        }
                    }
                    
                    ToolbarItem {
                        Button {
                            isSearching.toggle()
                        } label: {
                            Label("Search item", systemImage: "magnifyingglass")
                        }

                    }
                    ToolbarItem {
                        Button {
                            sortByDate.toggle()
                        } label: {
                            Label("Sort by Date", systemImage: "calendar")
                        }
                    }
                    
                    ToolbarItem {
                        Menu {
                            Button("High") {
                                selectedPriority = "High"
                            }
                            Button("Medium") {
                                selectedPriority = "Medium"
                            }
                            Button("Low") {
                                selectedPriority = "Low"
                            }
                            Button("All Priorities") {
                                selectedPriority = nil
                            }
                        } label: {
                            Image(systemName: "ellipsis.circle")
                        }
                        
                    }
                    
                }
            }
           
        }
        .sheet(isPresented: $isAddingTodo) {
            AddTodoView(isAddingTodo: $isAddingTodo)
        }

        
        
    }

    private func addTodo() {
        withAnimation {
            let newTodo = TodoItem(title: "")
            modelContext.insert(newTodo)
            saveChanges()
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
    
    private func toggleCompletion(for todo: TodoItem) {
        todo.isCompleted.toggle()
        saveChanges()
    }
    
    private func saveChanges() {
        do {
            try modelContext.save()
        } catch {
            print("Error saving changes: \(error.localizedDescription)")
        }
    }
    
    private func remainingTime(for dueDate: Date) -> String {
        let calendar = Calendar.current
        let currentDate = Date()
        
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
}

#Preview {
    ContentView()
        .modelContainer(for: TodoItem.self, inMemory: true)
}
