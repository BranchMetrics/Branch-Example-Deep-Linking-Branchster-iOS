//
//  AppNavigation.swift
//  Branch Monster Factory
//
//  Created by Robert Gioia on 11/5/25.
//

import BranchSDK
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
    private let completedChallengesKey = "completedChallengeTitles"
    private let lockedChallengesKey = "lockedChallengeTitles"
    private let audioPlayer = AudioPlayerHelper()
    var completedChallengeTitles: Set<String> = Set(
        UserDefaults.standard.stringArray(forKey: "completedChallengeTitles")
            ?? [])
    var lockedChallengeTitles: Set<String> = Set(
        UserDefaults.standard.stringArray(forKey: "lockedChallengeTitles")
            ?? [
                "Share Branch Link", "View Branch Event Data",
                "Share Branch QR Code",
            ])

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
        self.audioPlayer.playSound(sound: "quest_complete", type: "mp3")
        path = NavigationPath()
        if currentXP >= requiredXP { return }
        incrementXP(amount: 250.0, duration: 1.0)
    }

    func isChallengeComplete(_ challenge: Challenge) -> Bool {
        return completedChallengeTitles.contains(challenge.title)
    }

    func isChallengeLocked(_ challenge: Challenge) -> Bool {
        return lockedChallengeTitles.contains(challenge.title)
    }

    func markChallengeAsComplete(_ challenge: Challenge) {
        if completedChallengeTitles.insert(challenge.title).inserted {
            saveCompletedChallenges()
        }
    }

    private func saveCompletedChallenges() {
        let arrayToSave = Array(completedChallengeTitles)
        UserDefaults.standard.set(arrayToSave, forKey: completedChallengesKey)
    }

    func markChallengeAsUnlocked(_ challengeTitle: String) {
        lockedChallengeTitles.remove(challengeTitle)
        saveCompletedChallenges()
    }

    private func saveUnlockedChallenges() {
        let arrayToSave = Array(lockedChallengeTitles)
        UserDefaults.standard.set(arrayToSave, forKey: lockedChallengesKey)
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

        self.audioPlayer.playSound(sound: "evolving", type: "mp3")

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

    // --- BRANCH UNIVERSAL OBJECT (BUO) LOGIC ---

    /*
    Creates a fresh Branch Universal Object reflecting the current state of the monster.
    Since MonsterProgress is @Observable, this will always pull the latest data.
    */
    func createCurrentMonsterBUO() -> BranchUniversalObject {
        // Use a unique ID that reflects the monster's current state/level for deep linking
        let canonicalID = "monster-\(selectedColor):level-\(monsterLevel)"
        let monsterName =
            MonsterImages.shared.monsterNameMap[selectedColor] ?? "New Monster"

        let buo = BranchUniversalObject(canonicalIdentifier: canonicalID)

        buo.title = "Check out my Level \(monsterLevel) \(monsterName)!"
        buo.contentDescription =
            "My monster is on a quest! Current XP: \(Int(currentXP))/\(Int(requiredXP))."

        // Add all required data for deep link routing in customMetadata
        buo.contentMetadata.customMetadata["monster_color"] = selectedColor
        buo.contentMetadata.customMetadata["monster_level"] = String(
            monsterLevel)

        return buo
    }

    /**
     Generates the short URL and calls the completion handler with the result.
     */
    func generateMonsterShareLink(
        completion: @escaping (String?, Error?) -> Void
    ) {

        let buo = createCurrentMonsterBUO()

        let linkProperties = BranchLinkProperties()
        linkProperties.feature = "short_link"
        linkProperties.channel = "branchmonsterfactory2"
        linkProperties.campaign = "monster_share"

        linkProperties.controlParams["branch_link_type"] = "short_link"
        linkProperties.controlParams["$deeplink_path"] =
            "/\(selectedColor)/\(monsterLevel)"
        linkProperties.controlParams["monster_name"] =
            MonsterImages.shared.monsterNameMap[selectedColor]

        buo.getShortUrl(with: linkProperties) { url, error in
            completion(url, error)
        }
    }
}
