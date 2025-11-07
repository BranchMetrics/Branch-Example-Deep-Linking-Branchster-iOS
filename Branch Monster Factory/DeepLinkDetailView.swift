//
//  DeepLinkDetailView.swift
//  Branch Monster Factory
//
//  Created by Robert Gioia on 11/6/25.
//

import SwiftUI

struct DeepLinkDetailView: View {
    let monsterImage: String
    let monsterName: String

    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)

            VStack() {
                Text(monsterName)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)

                Image(monsterImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .foregroundColor(.orange)

                Text("Tap anywhere to close")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .padding(30)
            .frame(maxWidth: 300)
            .background(Color.black)
            .cornerRadius(12)
            .shadow(radius: 10)
        }.background(Color.black)
    }
}
