//
//  HomeScreen.swift
//  Branch Monster Factor
//
//  Created by Robert Gioia on 11/5/25.
//

import SwiftUI

struct Rotation3DModifier: ViewModifier {
    let angle: Angle

    func body(content: Content) -> some View {
        content.rotation3DEffect(angle, axis: (x: 0, y: 1, z: 0))
    }
}

extension AnyTransition {
    static var rotationFlip: AnyTransition {
        .asymmetric(
            insertion: AnyTransition.scale(scale: 0.5)
                .combined(with: .opacity)
                .combined(with: .modifier(
                    active: Rotation3DModifier(angle: Angle.degrees(180)),
                    identity: Rotation3DModifier(angle: Angle.degrees(0))
                )),
            removal: AnyTransition.scale(scale: 0.5)
                .combined(with: .opacity)
                .combined(with: .modifier(
                    active: Rotation3DModifier(angle: Angle.degrees(-180)),
                    identity: Rotation3DModifier(angle: Angle.degrees(0))
                ))
        )
    }
}

struct HomeScreen: View {
    @AppStorage("selectedMonsterName") private var selectedMonsterName: String = ""
    @Environment(AppNavigation.self) private var nav: AppNavigation

    let challenges = Challenges.shared.allChallenges
    
    private func getDisplayName(from assetName: String) -> String {
        return "Dusk Gleam \(nav.monsterLevel)"
//        return selectedMonsterName
//            .replacingOccurrences(of: "_", with: " ")
//            //.replacingOccurrences(of: "level 1", with: " ")
//            .capitalized
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
                        .transition(.rotationFlip)
                        .animation(.spring(response: 0.5, dampingFraction: 0.5, blendDuration: 0.5), value: nav.monsterLevel)
                        .id(nav.monsterLevel)
                        .overlay(
                            Circle()
                                .fill(nav.showEvolutionFlash ? Color.white.opacity(0.8) : Color.clear)
                                .frame(width: 350, height: 350)
                                .scaleEffect(nav.showEvolutionFlash ? 1.0 : 0.0)
                                .animation(.easeOut(duration: 0.2), value: nav.showEvolutionFlash)
                        )
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
            
//            .onAppear {
//                if nav.currentXP < nav.requiredXP {
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//                        nav.questCompleted()
//                    }
//                }
//            }
        }
    }
}
