//
//  AddTodoView.swift
//  Todo
//
//  Created by 최시온 on 1/17/25.
//

import SwiftUI

struct AddTodoView: View {
    @Environment(\.modelContext) private var modelContext
    @Binding var isAddingTodo: Bool
    @State private var title: String = ""
    @State private var priority: String = "Low"
    @State private var dueDate: Date = Date.now
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""

    
    let priorities = ["Low", "Medium", "High"]
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Title", text: $title)
                Picker("Priority", selection: $priority) {
                    ForEach(priorities, id: \.self) { priority in
                        Text(priority)
                    }
                }
                DatePicker("Due Date", selection: $dueDate, displayedComponents: [.date, .hourAndMinute])
                    .datePickerStyle(CompactDatePickerStyle())
                
            }
            .navigationTitle("Add Todo")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        isAddingTodo = false
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        if dueDate <= Date() {
                            alertMessage = "Please select a future date and time for the due date."
                            showAlert = true
                        } else if title.isEmpty {
                            alertMessage = "Title cannot be empty"
                            showAlert = true
                        }else {
                            addTodo()
                            isAddingTodo = false
                            showAlert = false
                        }
                    }

                }
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Invalid Date"),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
    
    private func addTodo() {
        let newTodo = TodoItem(title: title, priority: priority, dueDate: dueDate)
        modelContext.insert(newTodo)
    }
}

#Preview {
    
}
