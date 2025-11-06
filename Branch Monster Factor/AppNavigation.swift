//
//  AppNavigation.swift
//  Branch Monster Factory
//
//  Created by Robert Gioia on 11/5/25.
//

import SwiftUI

@Observable
class AppNavigation {
    var monsterLevel: Int = 1
    var path = NavigationPath()
    var currentXP: Double = 0.0
    let requiredXP: Double = 500.0
    var isAnimatingProgress = false
    var showEvolutionFlash: Bool = false
    var selectedColor: String
    
    init(initialXP: Double, initialColor: String) {
            self.currentXP = initialXP
            self.selectedColor = initialColor
    }

    func getMonsterAssetName() -> String {
        let levelIndex = self.monsterLevel - 1
        
        guard let assets = MonsterImages.shared.monsterAssets[self.selectedColor] else {
            return "yellow_monster_level_1"
        }
        
        if levelIndex >= 0 && levelIndex < assets.count {
            return assets[levelIndex]
        } else {
            return assets.last ?? "yellow_monster_level_1"
        }
    }
    
    func questCompleted() {
        if currentXP >= requiredXP { path = NavigationPath(); return }
        path = NavigationPath()
        incrementXP(amount: 250.0, duration: 1.0)
    }
    
    func incrementXP(amount: Double, duration: Double) {
        guard !isAnimatingProgress else { return }
        isAnimatingProgress = true
        let steps = 50
        let timeInterval = duration / Double(steps)
        let incrementPerStep = (amount / Double(steps))
        var currentStep = 0
        
        Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true) { timer in
            guard currentStep < steps else {
                timer.invalidate()
                self.isAnimatingProgress = false
                self.checkLevelUp()
                return
            }
            withAnimation(.easeInOut(duration: timeInterval)) {
                self.currentXP = min(self.requiredXP, self.currentXP + incrementPerStep)
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
        if currentXP >= requiredXP {
            withAnimation(.easeOut(duration: 0.2)) {
                self.showEvolutionFlash = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation(.spring(duration: 0.7, bounce: 0.4)) {
                    self.monsterLevel += 1
                    self.currentXP = 0.0
                    self.showEvolutionFlash = false
                }
            }
        }
    }
}
