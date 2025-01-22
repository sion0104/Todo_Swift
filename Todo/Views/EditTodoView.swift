//
//  EditTodoView.swift
//  Todo
//
//  Created by 최시온 on 1/22/25.
//

import SwiftUI

import SwiftUI

struct EditTodoView: View {
    @Environment(\.dismiss) private var dismiss
    
    let todo: TodoItem
    
    @State private var title: String = ""
    @State private var priority: Priority? = nil
    @State private var dueDate: Date? = nil
    @State private var isDueDateEnabled: Bool = false
    
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    
    var body: some View {
        Form {
            TextField("Title", text: $title)
                .border(title.isEmpty ? Color.red : Color.clear)
            
            Picker("Priority", selection: $priority) {
                ForEach(Priority.allCases, id: \.self) { priority in
                    Text(priority.title)
                }
            }
            
            Toggle("Due Date", isOn: $isDueDateEnabled)
            if isDueDateEnabled {
                DatePicker(
                    "Due Date",
                    selection: Binding(get: {
                        dueDate ?? Date()
                    }, set: {
                        dueDate = $0
                    }),
                    displayedComponents: [.date, .hourAndMinute]
                )
                .datePickerStyle(CompactDatePickerStyle())
                
                if let dueDate = dueDate, dueDate <= Date() {
                    Text("Due date must be in the future")
                        .foregroundColor(.red)
                        .font(.caption)
                }
            }
        }
        .navigationTitle("Edit Todo")
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    dismiss()
                }
            }
            
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    validateAndSave()
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
        .onAppear {
            title = todo.title
            priority = todo.priority
            dueDate = todo.dueDate
            isDueDateEnabled = todo.dueDate != nil
        }
    }
    
    private func validateAndSave() {
        if title.isEmpty {
            alertMessage = "Title cannot be empty"
            showAlert = true
        } else if isDueDateEnabled, let dueDate = dueDate, dueDate <= Date() {
            alertMessage = "Please select a future date and time for the due date."
            showAlert = true
        } else {
            todo.title = title
            todo.priority = priority
            todo.dueDate = isDueDateEnabled ? dueDate : nil
            dismiss()

        }
    }
}

#Preview {
    EditTodoView(todo: TodoItem(title: "HelloWorld!"))
}
