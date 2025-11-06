//
//  StepCardView.swift
//  Branch Monster Factory
//
//  Created by Robert Gioia on 11/5/25.
//

import SwiftUI

/*
    Steps for onboarding
 */

final class StepCardViewModel: ObservableObject {
    @Published var randomMonsters: [String] = []

    //pull three random monsters out of the 9 total
    func loadRandomMonsters() {
        guard randomMonsters.isEmpty else { return }
        randomMonsters = MonsterImages.shared.getThreeRandomLevel1Monsters()
    }

    func getDisplayName(from assetName: String) -> String {
        return assetName
            .replacingOccurrences(of: "_", with: " ")
            .replacingOccurrences(of: " level 1", with: "")
            .capitalized
    }

    func getColorKey(from assetName: String) -> String {
        return assetName.components(separatedBy: "_").first ?? "yellow"
    }
}

struct StepCardView: View {
    let step: OnboardingStep
    @Binding var isOnboardingComplete: Bool
    @Binding var selectedMonsterName: String
    @Environment(MonsterProgress.self) private var progress: MonsterProgress
    
    @StateObject private var viewModel = StepCardViewModel()

    let isLastStep: Bool

    private let primaryColor: Color = .white
    
    var body: some View {
        VStack(spacing: 20) {
            Image(step.imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxHeight: 400)

            Text(step.title)
                .font(
                    Font.custom("IBMPlexMono-Bold", size: 24, relativeTo: .body)
                )
                .fontWeight(.heavy)
                .foregroundColor(.white)
                .multilineTextAlignment(.leading)
                .padding(.horizontal, 10)

            if isLastStep {
                VStack(spacing: 20) {
                    if viewModel.randomMonsters.isEmpty {
                        ProgressView("Loading monsters...")
                            .foregroundColor(.white)
                            .padding()
                    } else {
                        ForEach(viewModel.randomMonsters, id: \.self) { monsterAssetName in
                            MonsterSelectButton(
                                imageName: monsterAssetName,
                                monsterName: viewModel.getDisplayName(from: monsterAssetName),
                                action: {
                                    let colorKey = viewModel.getColorKey(from: monsterAssetName)
                                    progress.selectedColor = colorKey
                                    selectedMonsterName = monsterAssetName
                                    isOnboardingComplete = true
                                }
                            )
                        }
                    }
                }
                .padding(.horizontal, 10)
                .onAppear {
                    viewModel.loadRandomMonsters()
                }
            } else {
                Text(step.description)
                    .font(
                        Font.custom("IBMPlexSans-Regular", size: 18, relativeTo: .body)
                    )
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal, 10)
            }
        }
        .padding(.horizontal, 40)
        .padding(.top, 20)
    }
}
