//
//  HomeScreen.swift
//  Branch Monster Factor
//
//  Created by Robert Gioia on 11/5/25.
//

import SwiftUI

struct HomeScreen: View {
    @AppStorage("selectedMonsterName") private var selectedMonsterName: String = ""
    @Environment(AppNavigation.self) private var nav: AppNavigation

    let challenges = Challenges.shared.allChallenges
    
    private func getDisplayName(from assetName: String) -> String {
        return assetName
            .replacingOccurrences(of: "_", with: " ")
            .replacingOccurrences(of: "level 1", with: " ")
            .capitalized
    }
    
    private var xpLabel: String {
        return "XP: \(Int(nav.currentXP)) / \(Int(nav.requiredXP))"
    }
            
    private var progressRatio: Double {
        return nav.currentXP / nav.requiredXP
    }
    
    private var monsterIconName: String {
        switch nav.monsterLevel {
            case 1: return "yellow_monster_level_1"
            case 2: return "yellow_monster_level_2"
            case 3: return "yellow_monster_level_3"
            case 4: return "yellow_monster_level_4"
            default: return "yellow_monster_level_4"
        }
    }

    var body: some View {
        ZStack {
            Color(red: 0.165, green: 0.176, blue: 0.196).edgesIgnoringSafeArea(
                .all)

            VStack {
                Text(
                    getDisplayName(from: selectedMonsterName)
                )
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.bottom, 20)

                VStack {
                    Image(monsterIconName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 300, height: 300)
                        .clipShape(Circle())
                        .shadow(radius: 10)
                        .transition(.scale(scale: 0.1).combined(with: .opacity))
                        .id(nav.monsterLevel)
                    
                    HStack {
                        ProgressView("Level \(nav.monsterLevel)", value: progressRatio, total: 1.0)
                            .progressViewStyle(.linear)
                            .tint(.pink)
                            .foregroundColor(.white)
                        
                        Text(xpLabel)
                            .foregroundColor(.white)
                            .font(.caption)
                    }
                    .padding()
                }
                .border(.white, width: 2)
                .padding()

                ScrollView {
                    VStack(spacing: 15) {

                        ForEach(challenges, id: \.title) { challenge in

                            VStack(alignment: .leading, spacing: 8) {
                                Text(challenge.title)
                                    .font(.headline)
                                    .foregroundColor(.white)

                                Text(
                                    challenge.description.first
                                        ?? "No description available"
                                )
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            }
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.clear)
                            .border(Color.white, width: 2)
                            .cornerRadius(5)

                        }
                    }
                    .padding(.horizontal)
                }

                Spacer()
            }
            
            .onAppear {
                if nav.currentXP < nav.requiredXP {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        nav.questCompleted()
                    }
                        
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                        nav.questCompleted()
                    }
                }
            }
        }
    }
}
