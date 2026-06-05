//
//  HomeScreen.swift
//  Branch Monster Factory
//
//  Created by Robert Gioia on 11/5/25.
//

import BranchSDK
import SwiftUI

/*
    The main screen of the app which provides the monsters and the quests
 */

struct HomeScreen: View {
    @AppStorage("selectedMonsterName") private var selectedMonsterName: String = ""
    @AppStorage("lastTrackedEventData") private var savedEventData: Data?

    @Environment(MonsterProgress.self) private var progress: MonsterProgress
    @Environment(DeepLinkHandler.self) private var deepLinkHandler

    @State private var generatedLink: String?
    @State private var isGeneratingLink: Bool = false
    @State private var showingLinkPopup: Bool = false
    @State private var generatedQRCode: UIImage?
    @State private var showingQRCodePopup: Bool = false
    @State private var showingEventDetailsPopup: Bool = false

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
                    print(
                        "Error creating Branch link: \(error?.localizedDescription ?? "Unknown error")"
                    )
                }
            }
        }
    }

    private func handleShareLinkQuest(challenge: Challenge) {
        let buo = progress.createCurrentMonsterBUO()

        let linkProperties = BranchLinkProperties()
        linkProperties.feature = "share_link_quest"
        linkProperties.channel = "branch_sheet"
        linkProperties.campaign = "monster_share"
        linkProperties.controlParams["$deeplink_path"] =
            "/\(progress.selectedColor)/\(progress.monsterLevel)"
        linkProperties.controlParams["monster_name"] =
            MonsterImages.shared.monsterNameMap[progress.selectedColor]

        let shareText =
            "Check out my Level \(progress.monsterLevel) monster, '\(self.getDisplayName())', in the updated Branch Monster Factory!"

        buo.showShareSheet(
            with: linkProperties,
            andShareText: shareText,
            from: nil
        ) { channel, completed, error in
            if completed {
                print(
                    "Shared successfully via: \(channel ?? "unknown channel")")

                DispatchQueue.main.async {
                    self.progress.markChallengeAsComplete(challenge)
                    self.progress.questCompleted()
                }
            } else {
                print("Share failed or was canceled.")
            }
        }
    }

    // MARK: - View Body
    var body: some View {
        ZStack {
            backgroundColor.edgesIgnoringSafeArea(.all)

            VStack {
                Text(getDisplayName())
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.bottom, 20)
                    .font(
                        Font.custom("IBMPlexSans-Bold", size: 18, relativeTo: .body)
                    )

                MonsterView(
                    monsterIconName: monsterIconName,
                    progressRatio: progressRatio,
                    xpLabel: xpLabel
                )
                ScrollView {
                    VStack(spacing: 15) {
                        ForEach(challenges, id: \.title) { challenge in
                            let challengeIsComplete =
                                progress.isChallengeComplete(challenge)
                            let challengeIsLocked = progress.isChallengeLocked(
                                challenge)

                            if !challengeIsComplete {
                                ChallengeRow(
                                    challenge: challenge,
                                    action: {
                                        switch challenge.title {
                                        case "Trigger Branch Event":
                                            let _ = trackEvent(
                                                monsterColor: progress.selectedColor,
                                                monsterLevel: progress.monsterLevel,
                                                selectedMonsterName: getDisplayName(),
                                                monsterExp: progress.currentXP
                                            )
                                            
                                            let localEvent = PersistedEventData(
                                                monsterName: getDisplayName(),
                                                monsterColor: progress.selectedColor,
                                                monsterLevel: progress.monsterLevel,
                                                monsterExp: progress.currentXP,
                                                timestamp: Date()
                                            )
                                            
                                            if let encoded = try? JSONEncoder().encode(localEvent) {
                                                self.savedEventData = encoded
                                            }

                                            progress.markChallengeAsComplete(challenge)
                                            progress.questCompleted()
                                            progress.markChallengeAsUnlocked("View Branch Event Data")
                                        case "View Branch Event Data":
                                            if self.savedEventData != nil {
                                                self.showingEventDetailsPopup = true
                                            } else {
                                                print("No event data from this or previous sessions available.")
                                            }
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
                                                selectedMonsterName: progress.getMonsterAssetName()
                                            )
                                        case "Create Branch Link":
                                            handleGenerateLinkQuest(challenge: challenge)
                                            progress.markChallengeAsUnlocked("Share Branch Link")
                                            break

                                        case "Share Branch Link":
                                            handleShareLinkQuest(challenge: challenge)
                                            break
                                            
                                        case "Share Branch QR Code":
                                            if let shareChallenge = challenges.first(where: { $0.title == "Share Branch QR Code" }) {
                                                let shareText = "Scan my QR code to view my Level \(progress.monsterLevel) monster, '\(self.getDisplayName())'!"
                                                
                                                let performShare: (UIImage) -> Void = { qrImage in
                                                    presentShareSheet(for: qrImage, and: shareText) { completed in
                                                        if completed {
                                                            DispatchQueue.main.async {
                                                                self.progress.markChallengeAsComplete(shareChallenge)
                                                                self.progress.questCompleted()
                                                            }
                                                        } else {
                                                            print("QR Code share failed or was canceled.")
                                                        }
                                                    }
                                                }
                                                
                                                if let qrImage = self.generatedQRCode {
                                                    performShare(qrImage)
                                                } else {
                                                    print("QR code missing for this session. Regenerating...")
                                                    createQRCode(
                                                        completion: { qrCodeImage in
                                                            DispatchQueue.main.async {
                                                                if let image = qrCodeImage {
                                                                    self.generatedQRCode = image
                                                                    performShare(image)
                                                                } else {
                                                                    print("Failed to auto-regenerate QR Code Image.")
                                                                }
                                                            }
                                                        },
                                                        monsterColor: progress.selectedColor,
                                                        monsterLevel: progress.monsterLevel,
                                                        selectedMonsterName: progress.getMonsterAssetName()
                                                    )
                                                }
                                            }
                                            break
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

            if deepLinkHandler.showingDeepLinkMonsterDetail {
                Color.black.opacity(0.4).edgesIgnoringSafeArea(.all)
                DeepLinkDetailView(
                    monsterImage: deepLinkHandler.deepLinkMonsterImage,
                    monsterName: deepLinkHandler.deepLinkMonsterName
                )
                .transition(.opacity.combined(with: .scale))
                .onTapGesture {
                    deepLinkHandler.showingDeepLinkMonsterDetail = false
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

            if showingEventDetailsPopup,
               let data = savedEventData,
               let decodedEvent = try? JSONDecoder().decode(PersistedEventData.self, from: data) {
                
                buildDetailsPopupView(for: decodedEvent)
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
                            progress.markChallengeAsComplete(completedChallenge)
                            progress.questCompleted()
                            progress.markChallengeAsUnlocked("Share Branch Link")
                        }
                    }
            }
        }
    }
    
    @ViewBuilder
    private func buildDetailsPopupView(for decodedEvent: PersistedEventData) -> some View {
        let displayEvent = BranchEvent.customEvent(withName: "Monster Event")
        
        // Safety Fallback pipeline: handles any unexpected zeroing properties out of serialization bounds
        let expString = decodedEvent.monsterExp > 0 ? String(Int(decodedEvent.monsterExp)) : String(Int(progress.currentXP))
        
        displayEvent.eventDescription = "Level: \(decodedEvent.monsterLevel) | Color: \(decodedEvent.monsterColor) | XP: \(expString)"
        displayEvent.transactionID = String(decodedEvent.monsterLevel)
        displayEvent.alias = decodedEvent.monsterColor
        displayEvent.searchQuery = expString
        
        displayEvent.customData = [
            "Monster Name": decodedEvent.monsterName,
            "Monster Color": decodedEvent.monsterColor,
            "Monster Level": String(decodedEvent.monsterLevel),
            "Monster Exp": expString,
            
            "monstername": decodedEvent.monsterName,
            "monstercolor": decodedEvent.monsterColor,
            "monsterlevel": String(decodedEvent.monsterLevel),
            "monsterexp": expString,
            
            "monster_name": decodedEvent.monsterName,
            "color": decodedEvent.monsterColor,
            "monster_color": decodedEvent.monsterColor,
            "monster_level": String(decodedEvent.monsterLevel),
            "monster_xp": expString,
            "monster_exp": expString,
            
            "level": String(decodedEvent.monsterLevel),
            "xp": expString,
            "exp": expString
        ]
        
        return DetailsPopupView(
            eventData: displayEvent,
            monsterName: decodedEvent.monsterName
        )
    }
}

func presentShareSheet(
    for image: UIImage,
    and text: String,
    completion: @escaping (Bool) -> Void
) {
    let activityViewController = UIActivityViewController(
        activityItems: [text, image],
        applicationActivities: nil
    )

    activityViewController.completionWithItemsHandler = { (activityType, completed, returnedItems, error) in
        completion(completed)
    }

    guard
        let window = UIApplication.shared.connectedScenes
        .filter({ $0.activationState == .foregroundActive })
        .compactMap({ $0 as? UIWindowScene })
        .first?.windows
        .filter({ $0.isKeyWindow }).first
    else {
        completion(false)
        return
    }

    if UIDevice.current.userInterfaceIdiom == .pad {
        if let popoverController = activityViewController.popoverPresentationController {
            popoverController.sourceView = window.rootViewController?.view
            popoverController.sourceRect = CGRect(x: window.frame.midX, y: window.frame.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
    }

    window.rootViewController?.present(activityViewController, animated: true)
}

struct PersistedEventData: Codable {
    let monsterName: String
    let monsterColor: String
    let monsterLevel: Int
    let monsterExp: Double
    let timestamp: Date
}
