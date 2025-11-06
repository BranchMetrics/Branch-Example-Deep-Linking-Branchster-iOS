//
//  Branch_Monster_FactorApp.swift
//  Branch Monster Factor
//
//  Created by Guru Prasadh on 05/11/25.
//

import SwiftUI
import Foundation

@main
struct Branch_Monster_FactorApp: App {

    @State private var nav: AppNavigation
    
    @AppStorage("persistentMonsterLevel") private var storedMonsterLevel: Int = 1
    @AppStorage("persistentMonsterExp") private var storedMonsterExp: Double = 0
    @AppStorage("persistentMonsterColor") private var storedMonsterColor: String = "yellow"

    init() {
        let defaults = UserDefaults.standard
        
        let initialLevel = defaults.integer(forKey: "persistentMonsterLevel")
        let initialExp = defaults.double(forKey: "persistentMonsterExp")
        let initialColor = defaults.string(forKey: "persistentMonsterColor") ?? "yellow"

        let safeLevel = initialLevel == 0 ? 1 : initialLevel
        
        _nav = State(
            initialValue: AppNavigation(
                initialXP: initialExp,
                initialLevel: safeLevel,
                initialColor: initialColor
            )
        )
    }

    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $nav.path) {
                OnboardingScreen()
            }
            .environment(nav)
            .onChange(of: nav.monsterLevel) { storedMonsterLevel = nav.monsterLevel }
            .onChange(of: nav.currentXP) { storedMonsterExp = nav.currentXP }
            .onChange(of: nav.selectedColor) { storedMonsterColor = nav.selectedColor }
        }
    }
}
