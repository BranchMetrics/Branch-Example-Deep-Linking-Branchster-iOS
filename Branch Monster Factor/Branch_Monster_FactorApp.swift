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
    @AppStorage("persistentMonsterLevel") private var storedMonsterLevel: Int =
        1
    @AppStorage("persistentMonsterExp") private var storedMonsterExp: Double = 0
    @AppStorage("persistentMonsterColor") private var storedMonsterColor:
        String = "yellow"

    init() {
        let initialLevel = UserDefaults.standard.integer(
            forKey: "persistentMonsterLevel")
        let initialExp = UserDefaults.standard.double(
            forKey: "persistentMonsterExp")
        let initialColor = UserDefaults.standard.string(forKey: "persistentMonsterColor") ?? "yellow"
        _nav = State(
            initialValue: AppNavigation(
                initialXP: initialExp, initialColor: initialColor))
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
                .onChange(of: nav.selectedColor) { _, newValue in
                    storedMonsterColor = newValue
                }
        }
    }
}
