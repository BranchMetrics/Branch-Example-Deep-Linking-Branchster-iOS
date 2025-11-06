//
//  Branch_Monster_FactorApp.swift
//  Branch Monster Factor
//
//  Created by Guru Prasadh on 05/11/25.
//

import SwiftData
import SwiftUI

@main
struct Branch_Monster_FactorApp: App {
    
    @State private var nav: AppNavigation
    @AppStorage("persistentMonsterLevel") private var storedMonsterLevel: Int = 1
    @AppStorage("persistentMonsterExp") private var storedMonsterExp: Double = 0

    init() {
        let initialLevel = UserDefaults.standard.integer(
            forKey: "persistentMonsterLevel")
        let initialExp = UserDefaults.standard.double(
            forKey: "persistentMonsterExp")
        _nav = State(initialValue: AppNavigation(initialXP: initialExp))
        nav.monsterLevel = initialLevel == 0 ? 1 : initialLevel
        nav.currentXP = initialExp
    }

    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $nav.path) {
                OnboardingScreen()
            }.environment(nav)
                .onChange(of: nav.monsterLevel) { oldValue, newValue in
                    storedMonsterLevel = newValue
                }
                .onChange(of: nav.currentXP) { oldValue, newValue in
                    storedMonsterExp = newValue
                }
        }
    }
}
