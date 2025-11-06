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
    @Environment(MonsterProgress.self) private var nav: MonsterProgress
  
    // 1. State to hold the challenges
    @State private var generatedLink: String?
    @State private var isGeneratingLink: Bool = false
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
  
    // LOGIC TO GENERATE AND SHARE BRANCH LINKS
      
    // Function to generates the link and store it in @State
    private func generateLink() {
        generatedLink = nil // Clear any old link
        isGeneratingLink = true
          
        nav.generateMonsterShareLink { url, error in
            DispatchQueue.main.async {
                self.isGeneratingLink = false
                if let urlString = url {
                    self.generatedLink = urlString // Store the generated link
                    print("Generated Link: \(urlString)")
                } else {
                    print("Error creating Branch link: \(error?.localizedDescription ?? "Unknown error")")
                    // Handle error (e.g., show an alert)
                }
            }
        }
    }
      
    // Function for Button 2: Opens the Share Sheet using the stored link
    private func showBranchShareSheet() {
        // 2a. Get the latest BUO data from the model
        let buo = nav.createCurrentMonsterBUO()
          
        // 2b. Define Link Properties for the share sheet
        let linkProperties = BranchLinkProperties()
        linkProperties.feature = "short_link"
        linkProperties.channel = "branchmonsterfactory2"
        linkProperties.campaign = "monster_share"
        // Add control parameters for the link (optional, but good for tracking)
        linkProperties.controlParams["branch_link_type"] = "short_link"
          
        // 2c. Define the message/text that accompanies the link
        let shareText = "Check out my Level \(nav.monsterLevel) monster, '\(self.getDisplayName())', in the updated Branch Monster Factory!"
          
        // 2d. Show the Branch Share Sheet
        buo.showShareSheet(
            with: linkProperties,
            andShareText: shareText,
            from: nil // Passing 'nil' here will allow the Branch SDK to find the current view controller
        ) { channel, completed, error in
            // This is the completion handler for the share activity
            if completed {
                print("Shared on \(channel ?? "unknown channel")")
            } else if let error = error {
                print("Error presenting or completing share sheet: \(error.localizedDescription)")
            } else {
                print("Share sheet dismissed or canceled.")
            }
        }
    }

    var body: some View {
        ZStack {
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
                            let challengeIsComplete =
                                progress.isChallengeComplete(
                                    challenge)

                            let challengeIsLocked = progress.isChallengeLocked(
                                challenge)

                            ChallengeRow(
                                challenge: challenge,
                                action: {

                                    switch challenge.title {
                                    case "Trigger Branch Event":
                                        self.eventData = trackEvent(
                                            monsterColor: progress
                                                .selectedColor,
                                            monsterLevel: progress.monsterLevel,
                                            selectedMonsterName: self
                                                .selectedMonsterName,
                                            monsterExp: progress.currentXP)
                                        progress.markChallengeAsComplete(
                                            challenge)
                                        progress.questCompleted()
                                        progress.markChallengeAsUnlocked(
                                            "View Branch Event Data")
                                        break
                                    case "View Branch Event Data":
                                        self.showingEventDetailsPopup = true
                                        break
                                    case "Generate Branch QR Code":
                                        createQRCode(
                                            completion: { qrCodeImage in
                                                DispatchQueue.main.async {
                                                    if let image = qrCodeImage {
                                                        self.generatedQRCode =
                                                            image
                                                        self.showingQRCodePopup = true
                                                    } else {
                                                        print(
                                                            "Failed to generate QR Code Image."
                                                        )
                                                    }
                                                }
                                            },
                                            monsterColor: progress
                                                .selectedColor,
                                            monsterLevel: progress.monsterLevel,
                                            selectedMonsterName: self
                                                .selectedMonsterName
                                        )
                                    default:
                                        break
                                    }
                                }, isCompleted: challengeIsComplete,
                                isLocked: challengeIsLocked)
                        }
                    }
                }
                .padding(.horizontal)
            }

            Spacer()
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
