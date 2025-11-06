//
//  AppNavigation.swift
//  Branch Monster Factory
//
//  Created by Robert Gioia on 11/5/25.
//

import Foundation
import SwiftUI

/*
    Keeps track of the monsters EXP progress and level up logic
 */

@Observable
class MonsterProgress {
    var monsterLevel: Int = 1
    var path = NavigationPath()
    var currentXP: Double = 0.0
    let requiredXP: Double = 500.0
    var isAnimatingProgress = false
    var showEvolutionFlash: Bool = false
    var selectedColor: String
    var completedChallengeTitles: Set<String> = []

    init(initialXP: Double, initialLevel: Int, initialColor: String) {
        self.currentXP = initialXP
        self.monsterLevel = initialLevel
        self.selectedColor = initialColor
    }

    func getMonsterAssetName() -> String {
        let levelIndex = self.monsterLevel - 1

        guard
            let assets = MonsterImages.shared.monsterAssets[self.selectedColor]
        else {
            return "yellow_monster_level_1"
        }

        if levelIndex >= 0 && levelIndex < assets.count {
            return assets[levelIndex]
        } else {
            return assets.last ?? "yellow_monster_level_1"
        }
    }

    func questCompleted() {
        path = NavigationPath()
        if currentXP >= requiredXP { return }
        incrementXP(amount: 250.0, duration: 1.0)
    }

    func isChallengeComplete(_ challenge: Challenge) -> Bool {
        return completedChallengeTitles.contains(challenge.title)
    }
    
    func markChallengeAsComplete(_ challenge: Challenge) {
        completedChallengeTitles.insert(challenge.title)
    }

    func incrementXP(amount: Double, duration: Double) {
        guard !isAnimatingProgress else { return }
        isAnimatingProgress = true
        let steps = 50
        let timeInterval = duration / Double(steps)
        let incrementPerStep = (amount / Double(steps))
        var currentStep = 0

        Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true) {
            [weak self] timer in
            guard let self = self else {
                timer.invalidate()
                return
            }

            guard currentStep < steps else {
                timer.invalidate()
                self.isAnimatingProgress = false
                self.checkLevelUp()
                return
            }

            withAnimation(.easeInOut(duration: timeInterval)) {
                self.currentXP = min(
                    self.requiredXP, self.currentXP + incrementPerStep)
            }
            currentStep += 1

            if self.currentXP >= self.requiredXP {
                timer.invalidate()
                self.isAnimatingProgress = false
                self.checkLevelUp()
            }
        }
    }

    func checkLevelUp() {
        guard currentXP >= requiredXP else { return }

        let flashDuration = 0.2
        let levelUpDelay = 0.2
        let levelUpDuration = 0.7

        withAnimation(.easeOut(duration: flashDuration)) {
            self.showEvolutionFlash = true
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + levelUpDelay) {
            withAnimation(.spring(duration: levelUpDuration, bounce: 0.4)) {
                self.monsterLevel += 1
                self.currentXP = 0.0
                self.showEvolutionFlash = false
            }
        }
    }
}
