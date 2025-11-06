//
//  Branch_Monster_FactorApp.swift
//  Branch Monster Factor
//
//  Created by Guru Prasadh on 05/11/25.
//

import SwiftUI
import Foundation

/*
    Entry point for the app
    Passed along the persistent data fields at the start of a session
 */
@main
struct Branch_Monster_FactorApp: App {
  
    @UIApplicationDelegateAdaptor(AppDelegateAdapter.self) var appDelegate

    @State private var progress: MonsterProgress
    
    @AppStorage("persistentMonsterLevel") private var storedMonsterLevel: Int = 1
    @AppStorage("persistentMonsterExp") private var storedMonsterExp: Double = 0
    @AppStorage("persistentMonsterColor") private var storedMonsterColor: String = "yellow"

    init() {
        let defaults = UserDefaults.standard
        
        let initialLevel = defaults.integer(forKey: "persistentMonsterLevel")
        let initialExp = defaults.double(forKey: "persistentMonsterExp")
        let initialColor = defaults.string(forKey: "persistentMonsterColor") ?? "yellow"

        let safeLevel = initialLevel == 0 ? 1 : initialLevel
        
        _progress = State(
            initialValue: MonsterProgress(
                initialXP: initialExp,
                initialLevel: safeLevel,
                initialColor: initialColor
            )
        )
    }

    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $progress.path) {
                OnboardingScreen()
            }
            .environment(progress)
            .onChange(of: progress.monsterLevel) { storedMonsterLevel = progress.monsterLevel }
            .onChange(of: progress.currentXP) { storedMonsterExp = progress.currentXP }
            .onChange(of: progress.selectedColor) { storedMonsterColor = progress.selectedColor }
        }
    }
}
