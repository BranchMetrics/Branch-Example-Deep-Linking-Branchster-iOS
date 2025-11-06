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
  
    // 1. State to hold the generated link
    @State private var generatedLink: String?
    @State private var isGeneratingLink: Bool = false

    let challenges = Challenges.shared.allChallenges
    
    private var backgroundColor: Color {
        Color(red: 0.165, green: 0.176, blue: 0.196)
    }
    
    private func getDisplayName() -> String {
        return MonsterImages.shared.monsterNameMap[nav.selectedColor] ?? "Unknown Monster"
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
              
                // Button 1: Generate Link
                Button(action: generateLink) {
                    HStack {
                        if isGeneratingLink {
                            ProgressView()
                        } else {
                            Text("Create Monster Share Link")
                        }
                    }
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(isGeneratingLink ? Color.gray : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .disabled(isGeneratingLink)
                .padding(.horizontal)
                .padding(.top, 10)
                              
                // Display the generated link (optional, good for debugging/copying)
                if let link = generatedLink {
                    Text("Link Ready: \(link)")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                        .padding(.horizontal)
                        .onTapGesture {
                            UIPasteboard.general.string = link // Allows easy copy on tap
                        }
                }
              
                // Button 2: Share Link (only enabled if a link exists)
                Button(action: showBranchShareSheet) {
                    Label("Share Monster", systemImage: "square.and.arrow.up")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(generatedLink == nil ? Color.gray : Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .disabled(generatedLink == nil) // Disable if no link is generated yet
                .padding(.horizontal)
                
                ScrollView {
                    VStack(spacing: 15) {
                        ForEach(challenges, id: \.title) { challenge in
                            ChallengeRow(challenge: challenge)
                        }
                    }
                    .padding(.horizontal)
                }

                Spacer()
            }
        }
    }
}
