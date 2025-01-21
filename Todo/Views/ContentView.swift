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
    
    @AppStorage("appearance") private var appearance: Appearance = .system

    @Query private var todos: [TodoItem]
    
    @State private var isAddingTodo = false
    @State private var searchText: String = ""
    @State private var isSearching = false
    @State private var sortByDate = false
    @State private var selectedPriority: String? = nil
    @State private var sortOption: SortOption = .byDateAscending
    @State private var opacity: Double = 0.0


    var filteredAndSortedTodos: [TodoItem] {
        let filteredTodos = filterTodos(todos)
        
        return sortTodos(filteredTodos)
    }

    private func filterTodos(_ todos: [TodoItem]) -> [TodoItem] {
        var result = todos
        
        if !searchText.isEmpty {
            let lowercasedSearchText = searchText.lowercased()
            result = result.filter { $0.title.lowercased().contains(lowercasedSearchText) }
        }
        
        if let selectedPriority = selectedPriority {
            result = result.filter { $0.priority == selectedPriority }
        }
        
        return result
    }

    private func sortTodos(_ todos: [TodoItem]) -> [TodoItem] {
        switch sortOption {
        case .byDateAscending:
            return todos.sorted {
                ($0.dueDate ?? .distantFuture) < ($1.dueDate ?? .distantFuture)
            }
        case .byDateDescending:
            return todos.sorted {
                ($0.dueDate ?? .distantPast) > ($1.dueDate ?? .distantPast)
            }
        case .byPriority:
            return todos.sorted { $0.priority < $1.priority }
        case .byTitle:
            return todos.sorted {
                $0.title.lowercased() < $1.title.lowercased()
            }
        }
    }

    var body: some View {
        NavigationStack {
            
            VStack (spacing: 0){

                if isSearching {
                    HStack {
                        TextField("Search", text: $searchText)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                            .transition(.move(edge: .top))
                            .animation(.easeInOut, value: searchText)
                        
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
                    ForEach(filteredAndSortedTodos) { todo in
                            HStack {
                                Button {
                                    withAnimation {
                                        toggleCompletion(for: todo)
                                    }

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
                                        .foregroundStyle(todo.isCompleted ? .secondary : .primary)
                                }
                                Spacer()
                                
                                Text(remainingTime(for: todo.dueDate))
                                    .foregroundStyle(.gray)
                                    .font(.footnote)
                                    .fixedSize()
                                
                                Image(systemName: icon(for: todo.priority))
                                    .foregroundStyle(color(for: todo.priority))
                                    .font(.title3)
                                
                            }
                            .background(todo.isCompleted ? Color.gray.opacity(0.1) : Color.clear)
                            .cornerRadius(8)
                        
                    }
                    .onDelete(perform: deleteTodo)
                }
                .contentMargins(10)
                .animation(.easeInOut, value: filteredAndSortedTodos)
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
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Menu {
                            Button("Sort by Date (Ascending)") { sortOption = .byDateAscending }
                            Button("Sort by Date (Descending)") { sortOption = .byDateDescending }
                            Button("Sort by Priority") { sortOption = .byPriority }
                            Button("Sort by Title") { sortOption = .byTitle }
                        } label: {
                            Label("Sort", systemImage: "arrow.up.arrow.down")
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Menu{
                            Button("System") { appearance = .system}
                            Button("Light") { appearance = .light}
                            Button("Dark") { appearance = .dark}
                        }label: {
                            Label("System Theme", systemImage: "ellipsis.circle.fill")
                        }
                    }
                    
                }
            }
           
        }
        .sheet(isPresented: $isAddingTodo) {
            AddTodoView(isAddingTodo: $isAddingTodo)
        }
        .opacity(opacity)
        .onAppear {
            withAnimation(.easeIn(duration: 0.5)){
                opacity = 1.0
            }
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
        
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: currentDate, to: dueDate)
        
        if let year = components.year, year > 0 {
            return "\(year)년 남음"
        } else if let month = components.month, month > 0 {
            return "\(month)달 남음"
        } else if let day = components.day, day > 0 {
            return "\(day)일 남음"
        } else if let hour = components.hour, hour > 0 {
            return "\(hour)시간 남음"
        } else if let minute = components.minute, minute > 0 {
            return "\(minute)분 남음"
        } else {
            return "기한 임박"
        }
    }
    
    private func icon(for priority: String) -> String {
        switch priority {
        case "High":
            return "arrowshape.up.circle.fill"
        case "Medium":
            return "minus.circle.fill"
        case "Low":
            return "arrowshape.down.circle.fill"
        default:
            return "questionmark.circle.fill"
        }
    }

    private func color(for priority: String) -> Color {
        switch priority {
        case "High":
            return .red
        case "Medium":
            return .orange
        case "Low":
            return .green
        default:
            return .gray
        }
    }
}







#Preview {
    ContentView()
        .modelContainer(for: TodoItem.self, inMemory: true)
}
