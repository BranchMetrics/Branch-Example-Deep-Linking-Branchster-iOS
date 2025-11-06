//
//  HomeScreen.swift
//  Branch Monster Factor
//
//  Created by Robert Gioia on 11/5/25.
//

import SwiftUI

/*
    The main screen of the app which provides the monsters and the quests
 */

struct HomeScreen: View {
    @AppStorage("selectedMonsterName") private var selectedMonsterName: String =
        ""
    @Environment(MonsterProgress.self) private var nav: MonsterProgress
    @State private var generatedQRCode: UIImage?
    @State private var showingPopup: Bool = false

    let challenges = Challenges.shared.allChallenges

    private var backgroundColor: Color {
        Color(red: 0.165, green: 0.176, blue: 0.196)
    }

    private func getDisplayName() -> String {
        return MonsterImages.shared.monsterNameMap[nav.selectedColor]
            ?? "Unknown Monster"
    }

    private var xpLabel: String {
        return "XP: \(Int(nav.currentXP)) / \(Int(nav.requiredXP))"
    }

    private var progressRatio: Double {
        return nav.currentXP / nav.requiredXP
    }

    private var monsterIconName: String {
        return nav.getMonsterAssetName()
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
                            ChallengeRow(challenge: challenge) {
                                switch challenge.title {
                                case "Generate Branch QR Code":
                                    createQRCode(
                                        completion: { qrCodeImage in
                                            DispatchQueue.main.async {
                                                if let image = qrCodeImage {
                                                    self.generatedQRCode = image
                                                    self.showingPopup = true
                                                } else {
                                                    print("Failed to generate QR Code Image.")
                                                }
                                            }
                                        },

                                        monsterColor: nav.selectedColor,
                                        monsterLevel: nav.monsterLevel
                                    )
                                default:
                                    break
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                }

                Spacer()
            }
            
            if showingPopup, let image = generatedQRCode {
                QRCodePopupView(image: image)
                    .transition(.opacity.combined(with: .scale))
                    .onTapGesture {
                        showingPopup = false
                    }
            }
        }
    }
}
