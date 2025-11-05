//
//  OnboardingScreen.swift
//  Branch Monster Factor
//
//  Created by Robert Gioia on 11/5/25.
//

import SwiftUI

struct OnboardingStep: Identifiable {
    let id = UUID()
    // FIX 1: Must declare type using a colon (:)
    let title: String
    let description: String
    let imageName: String
}

struct OnboardingScreen: View {
    @State private var currentPage: Int = 0
    // State variable to manage onboarding status
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
    // Use the custom dark gradient colors from our previous chat for a better look
    private let backgroundColor = Color(red: 0.165, green: 0.176, blue: 0.196)
    
    // FIX 2: Must declare type using a colon (:)
    private let cornerRadius: CGFloat = 12

    var body: some View {
        Group {
            if isOnboardingComplete {
                // You would show your main app view here
                Text("Home Screen").font(.largeTitle)
            } else {
                ZStack {
                    // FIX 3: Ignore safe area for the background color
                    backgroundColor.ignoresSafeArea(.all)
                    
                    VStack {
                        TabView(selection: $currentPage) {
                            ForEach(steps.indices, id: \.self) { index in
                                StepCardView(step: steps[index])
                                    .tag(index)
                            }
                        }
                        // FIX 4 & 5: Corrected PageTabViewStyle and removed extra modifiers/parentheses
                        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                        .animation(.easeInOut, value: currentPage)
                        
                        HStack(spacing: 10) {
                            ForEach(0..<steps.count, id: \.self) { index in
                                Circle()
                                    .fill(
                                        index == currentPage
                                            ? primaryColor.opacity(1)
                                            : primaryColor.opacity(0.3) // Use primaryColor opacity for better contrast
                                    )
                                    .frame(width: 10, height: 10)
                            }
                        }
                        // FIX 6: Corrected modifier name from .vetical to .vertical
                        .padding(.vertical, 20)

                        Button(action: handleNextButton) {
                            Text(
                                currentPage == steps.count - 1
                                    ? "Get Started!" : "Next"
                            )
                            .font(.headline)
                            .foregroundColor(backgroundColor) // Text contrast against primaryColor background
                            .frame(maxWidth: .infinity)
                            .padding()
                            // FIX 7: Swapped primaryColor and backgroundColor for button appearance
                            .background(primaryColor)
                            .cornerRadius(cornerRadius)
                        }
                        .padding(.horizontal, 40)
                        .padding(.bottom, 40)
                    }
                }
            }
        }
    }

    // Function is correct
    private func handleNextButton() {
        if currentPage < steps.count - 1 {
            currentPage += 1
        } else {
            isOnboardingComplete = true
        }
    }

    struct StepCardView: View {
        let step: OnboardingStep
        private let imageSize: CGFloat = 200
        var body: some View {
            VStack(spacing: 30) {
                Text(step.title)
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40) // Added horizontal padding for text

                Image(step.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: imageSize, height: imageSize)

                Text(step.description)
                    .font(.title3)
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                    // Removed maxHeight: .infinity to let the VStack control the spacing
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 40)
            }
        }
    }
}
