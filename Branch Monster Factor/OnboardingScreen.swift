//
//  OnboardingScreen.swift
//  Branch Monster Factor
//
//  Created by Robert Gioia on 11/5/25.
//

import SwiftUI

struct OnboardingScreen: View {
    @State private var currentPage: Int = 0
    @AppStorage("isOnboardingComplete") private var isOnboardingComplete: Bool = false
    @AppStorage("selectedMonsterName") private var selectedMonsterName: String = ""

    private let steps: [OnboardingStep] = [
        OnboardingStep(
            title: "See what Branch can do for you",
            description: "Complete challenges to learn about Branch functionality and capabilities",
            imageName: "onboarding_1"
        ),
        OnboardingStep(
            title: "Customize your monster",
            description: "Earn XP to unlock ways to customize your monster by completing challenges",
            imageName: "onboarding_2"
        ),
        OnboardingStep(
            title: "Select your monster",
            description: "Choose your unique starter monster to begin your journey!",
            imageName: "onboarding_3"
        ),
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
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(backgroundColor.opacity(0.001))
                    .cornerRadius(cornerRadius)
                }
                .padding(.horizontal, 40)
            } else {
                Color.clear.frame(height: 50)
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
                            .fill(index == currentPage ? primaryColor : primaryColor.opacity(0.3))
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
