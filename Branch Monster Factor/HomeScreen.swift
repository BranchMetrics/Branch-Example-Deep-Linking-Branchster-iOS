//
//  HomeScreen.swift
//  Branch Monster Factor
//
//  Created by Robert Gioia on 11/5/25.
//

import SwiftUI

struct HomeScreen: View {
    @AppStorage("selectedMonsterName") private var selectedMonsterName: String =
        ""

    let challenges = Challenges.shared.allChallenges
    
    private func getDisplayName(from assetName: String) -> String {
        return assetName
            .replacingOccurrences(of: "_", with: " ")
            .capitalized
    }

    var body: some View {
        ZStack {
            // Dark background color
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

                Image(selectedMonsterName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 300, height: 300)
                    .clipShape(Circle())
                    .shadow(radius: 10)

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
        }
    }
}
