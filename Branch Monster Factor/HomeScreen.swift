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
  
    // 1. State to hold the challenges
    @State private var generatedLink: String?
    @State private var isGeneratingLink: Bool = false
    @State private var showingLinkPopup: Bool = false
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
  
    /*
     1. Handles the 'Generate Branch Link' Quest.
        - Creates the link asynchronously and updates the state.
     */
    private func handleGenerateLinkQuest(challenge: Challenge) {
      self.generatedLink = nil
      self.isGeneratingLink = true
      
      progress.generateMonsterShareLink { url, error in
          DispatchQueue.main.async {
              self.isGeneratingLink = false
              if let urlString = url {
                  self.generatedLink = urlString
                  self.showingLinkPopup = true
                  
                  print("Created Link: \(urlString)")
              } else {
                  print("Error creating Branch link: \(error?.localizedDescription ?? "Unknown error")")
                  // On failure, do not mark challenge complete
              }
          }
      }
    }
      
    /*
     2. Handles the 'Share Branch Link' Quest.
        - Creates the BUO and presents the Branch Share Sheet immediately.
     */
    private func handleShareLinkQuest(challenge: Challenge) {
      let buo = progress.createCurrentMonsterBUO()
      
      let linkProperties = BranchLinkProperties()
      linkProperties.feature = "share_link_quest"
      linkProperties.channel = "branch_sheet"
      linkProperties.campaign = "monster_share"
      
      let shareText = "Check out my Level \(progress.monsterLevel) monster, '\(self.getDisplayName())', in the updated Branch Monster Factory!"
      
      buo.showShareSheet(
          with: linkProperties,
          andShareText: shareText,
          from: nil
      ) { channel, completed, error in
          if completed {
              print("Shared successfully via: \(channel ?? "unknown channel")")
              
              // Mark quest complete only AFTER the user successfully shares
              DispatchQueue.main.async {
                  self.progress.markChallengeAsComplete(challenge)
                  self.progress.questCompleted()
              }
          } else {
              print("Share failed or was canceled.")
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
                                    case "Create Branch Link":
                                        handleGenerateLinkQuest(challenge: challenge)
                                        progress.markChallengeAsUnlocked("Share Branch Link")
                                        break
                                                
                                    case "Share Branch Link":
                                          handleShareLinkQuest(challenge: challenge)
                                          break
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
        if showingLinkPopup, let link = generatedLink {
            LinkPopupView(link: link)
                .transition(.opacity.combined(with: .scale))
                .onTapGesture {
                    showingLinkPopup = false
                    if let completedChallenge = challenges.first(where: {
                        $0.title == "Create Branch Link"
                    }) {
                        // Mark completion and unlock the next quest (Share Branch Link)
                        progress.markChallengeAsComplete(completedChallenge)
                        progress.questCompleted()
                        progress.markChallengeAsUnlocked("Share Branch Link")
                    }
                }
        }
    }
}
