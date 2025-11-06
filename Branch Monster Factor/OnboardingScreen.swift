//
//  OnboardingScreen.swift
//  Branch Monster Factor
//
//  Created by Robert Gioia on 11/5/25.
//

import Foundation
import SwiftUI

struct OnboardingStep: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let imageName: String
}

struct MonsterSelectButton: View {
    let imageName: String
    let monsterName: String
    let action: () -> Void
    let cornerRadius: CGFloat
    let primaryColor: Color

    var body: some View {
        Button(action: action) {
            HStack {
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 60, height: 60)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 2))

                Text(monsterName)
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(primaryColor)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 8)

                Spacer()
            }
            .padding(8)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(primaryColor, lineWidth: 2)
            )
        }
    }
}

struct StepCardView: View {
    let step: OnboardingStep
    @Binding var isOnboardingComplete: Bool
    @Binding var selectedMonsterName: String
    @Environment(AppNavigation.self) private var nav: AppNavigation

    let isLastStep: Bool

    @State private var randomMonsters: [String] = []

    private let imageSize: CGFloat = 400
    private var primaryColor: Color { .white }
    private var cornerRadius: CGFloat { 12 }

    private func getDisplayName(from assetName: String) -> String {
        return
            assetName
            .replacingOccurrences(of: "_", with: " ")
            .replacingOccurrences(of: " level 1", with: "")
            .capitalized
    }

    private func getColorKey(from assetName: String) -> String {
        // e.g., converts "yellow_monster_level_1" to "yellow"
        return assetName.components(separatedBy: "_").first ?? "yellow"
    }

    var body: some View {
        VStack(spacing: 20) {
            Image(step.imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxHeight: 400)

            Text(step.title)
                .font(
                    Font.custom(
                        "IBMPlexMono-Bold", size: 24, relativeTo: .body)
                )
                .fontWeight(.heavy)
                .foregroundColor(.white)
                .multilineTextAlignment(.leading)
                .padding(.horizontal, 10)

            if isLastStep {

                VStack(spacing: 20) {

                    if randomMonsters.isEmpty {
                        ProgressView("Loading monsters...")
                            .foregroundColor(.white)
                            .padding()
                    } else {
                        ForEach(randomMonsters, id: \.self) {
                            monsterAssetName in
                            MonsterSelectButton(
                                imageName: monsterAssetName,
                                monsterName: getDisplayName(
                                    from: monsterAssetName),
                                action: {
                                    let colorKey = getColorKey(from: monsterAssetName)
                                    nav.selectedColor = colorKey
                                    selectedMonsterName = monsterAssetName
                                    isOnboardingComplete = true
                                },
                                cornerRadius: cornerRadius,
                                primaryColor: primaryColor
                            )
                        }
                    }
                }
                .padding(.horizontal, 10)
                .onAppear {
                    if randomMonsters.isEmpty {
                        randomMonsters = MonsterImages.shared
                            .getThreeRandomLevel1Monsters()
                    }
                }

            } else {
                Text(step.description)
                    .font(
                        Font.custom(
                            "IBMPlexSans-Regular", size: 18,
                            relativeTo: .body)
                    )
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal, 10)
            }
        }
        .padding(.horizontal, 40)
        .padding(.top, 20)
        .onChange(of: isLastStep) { newValue in
            if !newValue {
                randomMonsters = []
            }
        }
    }
}

struct OnboardingScreen: View {
    @State private var currentPage: Int = 0
    @AppStorage("isOnboardingComplete") private var isOnboardingComplete: Bool =
        false
    @AppStorage("selectedMonsterName") private var selectedMonsterName: String =
        ""

    private let steps: [OnboardingStep] = [
        OnboardingStep(
            title: "See what Branch can do for you",
            description:
                "Complete challenges to learn about Branch functionality and capabilities",
            imageName: "onboarding_1"),
        OnboardingStep(
            title: "Customize your monster",
            description:
                "Earn XP to unlock ways to customize your monster by completing challenges",
            imageName: "onboarding_2"),
        OnboardingStep(
            title: "Select your monster",
            description:
                "Choose your unique starter monster to begin your journey!",
            imageName: "onboarding_3"),
    ]

    private let primaryColor = Color.white
    private let backgroundColor = Color(red: 0.165, green: 0.176, blue: 0.196)
    private let cornerRadius: CGFloat = 12

    private var nextButtonArea: some View {
        VStack {
            if currentPage < steps.count - 1 {
                Button(action: handleNextButton) {
                    HStack(spacing: 8) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(primaryColor, lineWidth: 2)
                                .frame(width: 24, height: 24)

                            Image(systemName: "arrow.right")
                                .foregroundColor(primaryColor)
                                .font(.headline)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(backgroundColor.opacity(0.001))
                    .cornerRadius(cornerRadius)
                }
                .padding(.horizontal, 40)
            } else {
                Rectangle()
                    .fill(Color.clear)
                    .frame(height: 50)
            }
        }
    }

    private var onboardingContent: some View {
        ZStack {
            backgroundColor.ignoresSafeArea(.all)

            VStack {
                TabView(selection: $currentPage) {
                    ForEach(steps.indices, id: \.self) { index in
                        StepCardView(
                            step: steps[index],
                            isOnboardingComplete: $isOnboardingComplete,
                            selectedMonsterName: $selectedMonsterName,
                            isLastStep: index == steps.count - 1
                        )
                        .tag(index)
                    }
                }
                .tabViewStyle(
                    PageTabViewStyle(indexDisplayMode: .never)
                )
                .animation(.easeInOut, value: currentPage)

                nextButtonArea

                HStack(spacing: 10) {
                    ForEach(0..<steps.count, id: \.self) { index in
                        Circle()
                            .fill(
                                index == currentPage
                                    ? primaryColor.opacity(1)
                                    : primaryColor.opacity(0.3)
                            )
                            .frame(width: 10, height: 10)
                    }
                }
                .padding(.vertical, 20)
            }
        }
    }

    var body: some View {
        Group {
            if isOnboardingComplete {
                HomeScreen()
            } else {
                onboardingContent
            }
        }
    }

    private func handleNextButton() {
        if currentPage < steps.count - 1 {
            currentPage += 1
        }
    }
}
