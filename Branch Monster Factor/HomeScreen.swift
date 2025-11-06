//
//  HomeScreen.swift
//  Branch Monster Factor
//
//  Created by Robert Gioia on 11/5/25.
//

import SwiftUI
import BranchSDK

/*
    The main screen of the app which provides the monsters and the quests
 */

struct HomeScreen: View {
    @AppStorage("selectedMonsterName") private var selectedMonsterName: String = ""
    @Environment(MonsterProgress.self) private var progress: MonsterProgress
    
    // MARK: - New State for Deep Link Handling
    @State private var showingDeepLinkMonsterDetail: Bool = false
    @State private var deepLinkMonsterImage: String = ""
    @State private var deepLinkMonsterName: String = ""
    
    // Existing State
    @State private var generatedQRCode: UIImage?
    @State private var showingQRCodePopup: Bool = false
    @State private var showingEventDetailsPopup: Bool = false
    @State private var eventData: BranchEvent?

    let challenges = Challenges.shared.allChallenges

    private var backgroundColor: Color {
        Color(red: 0.165, green: 0.176, blue: 0.196)
    }

    private func getDisplayName() -> String {
        return MonsterImages.shared.monsterNameMap[progress.selectedColor]
            ?? "Unknown Monster"
    }

    private var xpLabel: String {
        return "XP: \(Int(progress.currentXP)) / \(Int(progress.requiredXP))"
    }

    private var progressRatio: Double {
        return progress.currentXP / progress.requiredXP
    }

    private var monsterIconName: String {
        return progress.getMonsterAssetName()
    }

    // MARK: - Deep Link Logic Function
    private func handleDeepLinkDisplay() {
        print("Inside handleDeepLinkDisplay")
        
        let sessionParams = Branch.getInstance().getLatestReferringParams()
        let safeSessionParams = sessionParams ?? NSDictionary() as! [AnyHashable : Any]

        // 1. Check the "+clicked_branch_link" flag safely
        guard let clickedValue = safeSessionParams["+clicked_branch_link"] else {
            print("Branch flag not present.")
            return
        }
        
        // Safely determine if the link was clicked (handles both Bool and String "true")
        guard let wasBranchLinkClicked = clickedValue as? Bool else { return }
        
        guard wasBranchLinkClicked else {
            print("Session not initiated by a Branch link click.")
            return
        }
        
        // 2. Extract Data and check if it's valid
        let assetName = MonsterImages.shared.getDeeplinkImage(params: safeSessionParams as NSDictionary)
        let name = (safeSessionParams["monster_name"] as? String) ?? "Mysterious Monster"
        
        if !assetName.isEmpty {
            // 3. Update State variables
            self.deepLinkMonsterImage = assetName
            self.deepLinkMonsterName = name
            self.showingDeepLinkMonsterDetail = true
            print("Deep Link found and state updated: \(name) (\(assetName))")
        }
    }

    // MARK: - View Body
    var body: some View {
        ZStack {
            // --------------------
            // 1. Primary Content Layer
            // --------------------
            backgroundColor.edgesIgnoringSafeArea(.all)

            VStack {
                Text(getDisplayName())
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.bottom, 20)

                MonsterView(
                    monsterIconName: monsterIconName,
                    progressRatio: progressRatio,
                    xpLabel: xpLabel
                )

                ScrollView {
                    VStack(spacing: 15) {
                        ForEach(challenges, id: \.title) { challenge in
                            let challengeIsComplete = progress.isChallengeComplete(challenge)
                            let challengeIsLocked = progress.isChallengeLocked(challenge)
                            
                            if(!challengeIsComplete) {
                                ChallengeRow(
                                    challenge: challenge,
                                    action: {
                                        switch challenge.title {
                                        case "Trigger Branch Event":
                                            self.eventData = trackEvent(
                                                monsterColor: progress.selectedColor,
                                                monsterLevel: progress.monsterLevel,
                                                selectedMonsterName: self.selectedMonsterName,
                                                monsterExp: progress.currentXP)
                                            progress.markChallengeAsComplete(challenge)
                                            progress.questCompleted()
                                            progress.markChallengeAsUnlocked("View Branch Event Data")
                                        case "View Branch Event Data":
                                            self.showingEventDetailsPopup = true
                                        case "Generate Branch QR Code":
                                            createQRCode(
                                                completion: { qrCodeImage in
                                                    DispatchQueue.main.async {
                                                        if let image = qrCodeImage {
                                                            self.generatedQRCode = image
                                                            self.showingQRCodePopup = true
                                                        } else {
                                                            print("Failed to generate QR Code Image.")
                                                        }
                                                    }
                                                },
                                                monsterColor: progress.selectedColor,
                                                monsterLevel: progress.monsterLevel,
                                                selectedMonsterName: self.selectedMonsterName
                                            )
                                        default:
                                            break
                                        }
                                    }, isCompleted: challengeIsComplete,
                                    isLocked: challengeIsLocked)
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
            Spacer()
            
            // 4. Run the Deep Link logic on appear
            .onAppear {
                handleDeepLinkDisplay()
            }


            // --------------------
            // 2. Pop-up/Modal Layers
            // --------------------
            
            // Deep Link Detail View (Conditional Rendering Fix)
            if showingDeepLinkMonsterDetail {
                Color.black.opacity(0.4).edgesIgnoringSafeArea(.all) // Dimming background
                DeepLinkDetailView(
                    monsterImage: deepLinkMonsterImage,
                    monsterName: deepLinkMonsterName
                )
                .transition(.opacity.combined(with: .scale))
                .onTapGesture {
                    // When tapped, dismiss the detail view and mark challenge complete
                    showingDeepLinkMonsterDetail = false
                    if let completedChallenge = challenges.first(where: { $0.title == "View Branch Event Data" /* Placeholder challenge title */ }) {
                        progress.markChallengeAsComplete(completedChallenge)
                        progress.questCompleted()
                    }
                }
            }


            if showingQRCodePopup, let image = generatedQRCode {
                QRCodePopupView(image: image)
                    .transition(.opacity.combined(with: .scale))
                    .onTapGesture {
                        showingQRCodePopup = false
                        if let completedChallenge = challenges.first(where: {
                            $0.title == "Generate Branch QR Code"
                        }) {
                            progress.markChallengeAsComplete(completedChallenge)
                            progress.questCompleted()
                            progress.markChallengeAsUnlocked("Share Branch QR Code")
                        }
                    }
            }
            
            if showingEventDetailsPopup {
                DetailsPopupView(eventData: self.eventData!, monsterName: getDisplayName())
                    .transition(.opacity.combined(with: .scale))
                    .onTapGesture {
                        showingEventDetailsPopup = false
                        if let completedChallenge = challenges.first(where: {
                            $0.title == "View Branch Event Data"
                        }) {
                            progress.markChallengeAsComplete(completedChallenge)
                            progress.questCompleted()
                        }
                    }
            }
        }
    }
}
