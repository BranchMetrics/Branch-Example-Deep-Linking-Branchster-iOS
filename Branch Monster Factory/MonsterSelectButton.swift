//
//  MonsterSelectButton.swift
//  Branch Monster Factory
//
//  Created by Robert Gioia on 11/5/25.
//

import SwiftUI

/*
    Button to select starter monster during onboarding flow
 */

struct MonsterSelectButton: View {
    let imageName: String
    let monsterName: String
    let action: () -> Void
    
    private let cornerRadius: CGFloat = 12
    private let primaryColor: Color = .white

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
                    .font(
                        Font.custom("IBMPlexSans-Regular", size: 18, relativeTo: .body)
                    )

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
