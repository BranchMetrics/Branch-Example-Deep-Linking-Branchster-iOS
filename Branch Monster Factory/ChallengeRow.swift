//
//  ChallengeRow.swift
//  Branch Monster Factory
//
//  Created by Robert Gioia on 11/5/25.
//

import SwiftUI

/*
    Content for a challenge/quest
 */

struct ChallengeRow: View {
    let challenge: Challenge
    let action: () -> Void
    let isCompleted: Bool
    let isLocked: Bool

    var body: some View {
        Button(action: action) {
            HStack {
                Image(isLocked ? "lock" : challenge.imageName)
                    .frame(width: 100, height: 100)
                VStack(alignment: .leading, spacing: 8) {
                    Text(challenge.title)
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    Text(challenge.description)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .border(Color.white, width: 2)
            .cornerRadius(5)
            
        }.buttonStyle(PlainButtonStyle())
            .disabled(isCompleted || isLocked)
            .opacity(isCompleted || isLocked ? 0.5 : 1.0)
    }
}
