//
//  TodoApp.swift
//  Todo
//
//  Created by 최시온 on 1/17/25.
//

import SwiftUI
import SwiftData

@main
struct TodoApp: App {
    @AppStorage("appearance") private var appearance: Appearance = .system

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            TodoItem.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(appearance.colorScheme)
        }
        .modelContainer(sharedModelContainer)
    }
}
