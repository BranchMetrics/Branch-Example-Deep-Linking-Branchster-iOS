//
//  OnboardingScreen.swift
//  Branch Monster Factor
//
//  Created by Robert Gioia on 11/5/25.
//

import SwiftUI

struct OnboardingStep: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let imageName: String
}

struct MonsterSelectButton: View {
    let monsterName: String
    let action: () -> Void
    let cornerRadius: CGFloat
    let primaryColor: Color

    var body: some View {
        Button(action: action) {
            Text(monsterName)
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundColor(primaryColor)
                .padding(.vertical, 10)
                .padding(.horizontal, 8)
                .frame(maxWidth: .infinity)
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(primaryColor, lineWidth: 2)
                )
        }
    }
}

struct OnboardingScreen: View {
    @State private var currentPage: Int = 0
    @AppStorage("isOnboardingComplete") private var isOnboardingComplete: Bool = false

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
            description: "",
            imageName: "onboarding_3"),
    ]

    private let primaryColor = Color.white
    private let backgroundColor = Color(red: 0.165, green: 0.176, blue: 0.196)
    private let cornerRadius: CGFloat = 12

    var body: some View {
        Group {
//            if isOnboardingComplete {
//                // You would show your main app view here
//                Text("Home Screen").font(.largeTitle)
//            } else {
                ZStack {
                    backgroundColor.ignoresSafeArea(.all)

                    VStack {
                        TabView(selection: $currentPage) {
                            ForEach(steps.indices, id: \.self) { index in
                                StepCardView(
                                    step: steps[index],
                                    isOnboardingComplete: $isOnboardingComplete, isLastStep: index == steps.count - 1
                                )
                                .tag(index)
                            }
                        }
                        .tabViewStyle(
                            PageTabViewStyle(indexDisplayMode: .never)
                        )
                        .animation(.easeInOut, value: currentPage)

                        // Page Indicator Dots

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
                                .background(backgroundColor)
                                .cornerRadius(cornerRadius)
                            }
                            .padding(.horizontal, 40)
                            .padding(.bottom, 40)
                        } else {
                            Spacer()
                        }
                    }
//                }
            }
        }
    }

    private func handleNextButton() {
        if currentPage < steps.count - 1 {
            currentPage += 1
        } else {
            isOnboardingComplete = true
        }
    }

    struct StepCardView: View {
        let step: OnboardingStep
        @Binding var isOnboardingComplete: Bool

        let isLastStep: Bool
        private let imageSize: CGFloat = 400
        private var primaryColor: Color { .white }
        private var cornerRadius: CGFloat { 12 }

        var body: some View {
            VStack(spacing: 20) {
                Image(step.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: imageSize, height: imageSize)

                Text(step.title)
                    .font(
                        Font.custom(
                            "IBMPlexMono-Bold", size: 24, relativeTo: .body)
                    )
                    .fontWeight(.heavy)
                    .foregroundColor(.white)
                    .frame(width: 400)
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal, 10)

                if isLastStep {
                    VStack(spacing: 20) {
                        MonsterSelectButton(
                            monsterName: "Monster Name 1",
                            action: { isOnboardingComplete = true },
                            cornerRadius: cornerRadius,
                            primaryColor: primaryColor
                        )
                        MonsterSelectButton(
                            monsterName: "Monster Name 2",
                            action: { isOnboardingComplete = true },
                            cornerRadius: cornerRadius,
                            primaryColor: primaryColor
                        )
                        MonsterSelectButton(
                            monsterName: "Monster Name 3",
                            action: { isOnboardingComplete = true },
                            cornerRadius: cornerRadius,
                            primaryColor: primaryColor
                        )
                    }
                    .padding(.horizontal, 10)

                } else {
                    Text(step.description)
                        .font(
                            Font.custom(
                                "IBMPlexSans-Regular", size: 18, relativeTo: .body)
                        )
                        .foregroundColor(.white.opacity(0.8))
                        .multilineTextAlignment(.leading)
                        .frame(width: 400)
                        .padding(.horizontal, 10)
                }
            }
        }
    }
}
