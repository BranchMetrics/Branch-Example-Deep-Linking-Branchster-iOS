//
//  AppNavigation.swift
//  Branch Monster Factory
//
//  Created by Robert Gioia on 11/5/25.
//

import SwiftUI

@Observable
class AppNavigation {
    var path = NavigationPath()
    var currentXP: Double = 250.0
    let requiredXP: Double = 500.0
    
    var monsterLevel: Int = 1
    var isAnimatingProgress = false

    func questCompleted() {
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
            monsterLevel += 1
            currentXP = 0.0
            print("MONSTER LEVELED UP to Level \(monsterLevel)!")
        }
    }
}
