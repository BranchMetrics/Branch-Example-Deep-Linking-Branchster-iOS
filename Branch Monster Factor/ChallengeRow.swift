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

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 8) {
                Text(challenge.title)
                    .font(.headline)
                    .foregroundColor(.white)
                
                Text(challenge.description)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .border(Color.white, width: 2)
            .cornerRadius(5)
        }.buttonStyle(PlainButtonStyle())
    }
}
