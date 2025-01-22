//
//  AddTodoView.swift
//  Todo
//
//  Created by 최시온 on 1/17/25.
//

import SwiftUI

struct AddTodoView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State var isAddingTodo: Bool = false
    @State private var title: String = ""
    @State private var priority: Priority? = nil
    @State private var dueDate: Date? = nil
    @State private var isDueDateEnabled: Bool = false
    
    
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""


    
    var body: some View {
        NavigationView {
            Form {
                TextField("Title", text: $title)
                
                Picker("Priority", selection: $priority) {
                    ForEach(Priority.allCases, id: \.self) { priority in
                        Text(priority.title)
                    }
                }
                Toggle("Due Date", isOn: $isDueDateEnabled)
                if isDueDateEnabled {
                    DatePicker("Due Date", selection: Binding(get: {
                        dueDate ?? Date()
                    }, set: {
                        dueDate = $0
                    }), displayedComponents: [.date, .hourAndMinute])
                        .datePickerStyle(CompactDatePickerStyle())
                }
            }
            .navigationTitle("Add Todo")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        isAddingTodo = false
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        if dueDate != nil, dueDate ?? Date() <= Date() {
                            alertMessage = "Please select a future date and time for the due date."
                            showAlert = true
                        } else if title.isEmpty {
                            alertMessage = "Title cannot be empty"
                            showAlert = true
                        }else {
                            isAddingTodo = false
                            showAlert = false
                            addTodo()
                        }
                    }

                }
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Invalid Todo"),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
    
    private func addTodo() {
        let newTodo = TodoItem(title: title, priority: nil, dueDate: dueDate)
        modelContext.insert(newTodo)
        dismiss()
    }
}

#Preview {
    AddTodoView()
        .modelContainer(for: TodoItem.self, inMemory: true)
}
