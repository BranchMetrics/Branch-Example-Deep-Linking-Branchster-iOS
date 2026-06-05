//
//  HomeScreen.swift
//  Branch Monster Factor
//
//  Created by Robert Gioia on 11/5/25.
//

import BranchSDK
import SwiftUI

/*
    The main screen of the app which provides the monsters and the quests
 */

struct HomeScreen: View {
    @AppStorage("selectedMonsterName") private var selectedMonsterName: String =
        ""

    @Environment(MonsterProgress.self) private var progress: MonsterProgress
    @Environment(DeepLinkHandler.self) private var deepLinkHandler

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
                                            self.eventData = trackEvent(
                                                monsterColor: progress
                                                    .selectedColor,
                                                monsterLevel: progress
                                                    .monsterLevel,
                                                selectedMonsterName: self
                                                    .selectedMonsterName,
                                                monsterExp: progress.currentXP)
                                            progress.markChallengeAsComplete(
                                                challenge)
                                            progress.questCompleted()
                                            progress.markChallengeAsUnlocked(
                                                "View Branch Event Data")
                                        case "View Branch Event Data":
                                            self.showingEventDetailsPopup = true
                                        case "Generate Branch QR Code":
                                            createQRCode(
                                                completion: { qrCodeImage in
                                                    DispatchQueue.main.async {
                                                        if let image =
                                                            qrCodeImage
                                                        {
                                                            self
                                                                .generatedQRCode =
                                                                image
                                                            self
                                                                .showingQRCodePopup =
                                                                true
                                                        } else {
                                                            print(
                                                                "Failed to generate QR Code Image."
                                                            )
                                                        }
                                                    }
                                                },
                                                monsterColor: progress
                                                    .selectedColor,
                                                monsterLevel: progress
                                                    .monsterLevel,
                                                selectedMonsterName:
                                                    progress.getMonsterAssetName()
                                            )
                                        case "Create Branch Link":
                                            handleGenerateLinkQuest(
                                                challenge: challenge)
                                            progress.markChallengeAsUnlocked(
                                                "Share Branch Link")
                                            break

                                        case "Share Branch Link":
                                            handleShareLinkQuest(
                                                challenge: challenge)
                                            break
                                        case "Share Branch QR Code":
                                            if let shareChallenge = challenges.first(where: { $0.title == "Share Branch QR Code" }) {
                                                let shareText = "Scan my QR code to view my Level \(progress.monsterLevel) monster, '\(self.getDisplayName())'!"
                                                
                                                // Helper closure so we don't duplicate the share sheet presentation logic
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
                                                
                                                // Check if we already have the QR code in memory
                                                if let qrImage = self.generatedQRCode {
                                                    performShare(qrImage)
                                                } else {
                                                    // It's a new session and the image is nil! Let's auto-generate it on the fly.
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
                            progress.markChallengeAsUnlocked(
                                "Share Branch QR Code")
                        }
                    }
            }

            if showingEventDetailsPopup {
                DetailsPopupView(
                    eventData: self.eventData!, monsterName: getDisplayName()
                )
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

func presentShareSheet(
    for image: UIImage,
    and text: String,
    completion: @escaping (Bool) -> Void
) {
    let activityViewController = UIActivityViewController(
        activityItems: [text, image],
        applicationActivities: nil
    )

    // Set the completion handler
    activityViewController.completionWithItemsHandler = {
        (activityType, completed, returnedItems, error) in
        completion(completed)
    }

    // Get the root view controller to present from
    // This is a common way to bridge SwiftUI to UIKit's presentation logic
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

    // Handle iPad popover presentation
    if UIDevice.current.userInterfaceIdiom == .pad {
        if let popoverController = activityViewController
            .popoverPresentationController
        {
            // Present from the center of the screen or an actual view if you have one readily available
            popoverController.sourceView = window.rootViewController?.view
            popoverController.sourceRect = CGRect(
                x: window.frame.midX, y: window.frame.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []  // No arrow needed if presenting from center
        }
    }

    window.rootViewController?.present(activityViewController, animated: true)
}
