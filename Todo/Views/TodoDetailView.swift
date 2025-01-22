//
//  TodoDetailView.swift
//  Todo
//
//  Created by 최시온 on 1/17/25.
//

import SwiftUI

struct TodoDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.presentationMode) private var presentationMode
    @State var todo: TodoItem
    @State private var editedTitle: String
    @State private var selectedPrioirity: Priority?
    @State private var dueDate: Date?
    @State private var isDueDateEnabled: Bool = false
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    
    let priorities = ["Low", "Medium", "High"]

    init(todo: TodoItem) {
        self.todo = todo
        _editedTitle = State(initialValue: todo.title)
        _selectedPrioirity = State(initialValue: todo.priority)
        _dueDate = State(initialValue: todo.dueDate)
    }
    
    var body: some View {
        Form {
            Section(header: Text("Task information")) {
                TextField("Title", text: $editedTitle)
                
                Picker("Priority", selection: $selectedPrioirity) {
                    ForEach(priorities, id: \.self) { priority in
                        Text(priority)
                    }
                }
            }
            
            Section(header: Text("Task information")) {
                Toggle("마감일 설정", isOn: $isDueDateEnabled)
                if isDueDateEnabled {
                    DatePicker("Due Date", selection: Binding(get: {
                        dueDate ?? Date()
                    }, set: {
                        dueDate = $0
                    }), displayedComponents: [.date, .hourAndMinute])
                        .datePickerStyle(CompactDatePickerStyle())
                }
            }
            
            Section {
                Button("Save Changes"){
                    if dueDate != nil, ( dueDate ?? Date() ) <= Date() {
                        alertMessage = "Please select a future date and time for the due date."
                        showAlert = true
                    } else if editedTitle.isEmpty {
                        alertMessage = "Title cannot be empty"
                        showAlert = true
                    }else {
                        saveChanges()
                        showAlert = false
                    }
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Invalid Input"),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
        .navigationTitle("Todo Details")
    }
    
    private func saveChanges() {
        todo.title = editedTitle
        todo.priority = selectedPrioirity
        todo.dueDate = dueDate
        do {
            try modelContext.save()
            presentationMode.wrappedValue.dismiss()
        } catch {
            print("Error saving changes: \(error.localizedDescription)")
        }
    }
}

#Preview {
    TodoDetailView(todo: TodoItem(title: "Sample1", dueDate: Date.now))
}
