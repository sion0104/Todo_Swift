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
    
    @State private var isAddingTodo: Bool
    @State private var searchText: String
    @State private var sortByDate = false
    @State private var selectedPriority: Priority?
    @State private var sortOption: SortOption
    @State private var opacity: Double
    
    
    init(isAddingTodo: Bool = false, searchText: String = "", sortByDate: Bool = false, selectedPriority: Priority? = nil, sortOption: SortOption = .byDateAscending, opacity: Double = 0.0) {
        self.isAddingTodo = isAddingTodo
        self.searchText = searchText
        self.sortByDate = sortByDate
        self.selectedPriority = selectedPriority
        self.sortOption = sortOption
        self.opacity = opacity
    }
    
        var body: some View {
            NavigationStack {
                VStack (spacing: 0){
                    TodoListView(searchText: searchText, selectedPriority: selectedPriority)
                        .searchable(text: $searchText)
                        .contentMargins(10)
                        .navigationTitle("Todo List")
                        .toolbar {
                            ToolbarItem {
                                Button(action: {
                                    isAddingTodo = true
                                }) {
                                    Label("Add Item", systemImage: "plus")
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
            .sheet(isPresented: $isAddingTodo, onDismiss: {
                sortOption = .byDateAscending
            }) {
                AddTodoView()
            }
            .opacity(opacity)
            .onAppear {
                withAnimation(.easeIn(duration: 0.5)){
                    opacity = 1.0
                }
            }
            
        }
}
    




#Preview {
    ContentView()
        .modelContainer(for: TodoItem.self, inMemory: true)
}



