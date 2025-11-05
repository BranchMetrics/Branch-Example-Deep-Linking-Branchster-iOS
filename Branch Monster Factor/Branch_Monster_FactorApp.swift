//
//  Branch_Monster_FactorApp.swift
//  Branch Monster Factor
//
//  Created by Guru Prasadh on 05/11/25.
//

import SwiftUI
import SwiftData

@main
struct Branch_Monster_FactorApp: App {
    
    @State private var nav = AppNavigation()
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
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
            NavigationStack(path: $nav.path) {
                OnboardingScreen()
            }.environment(nav)
        }
        .modelContainer(sharedModelContainer)
    }
}
