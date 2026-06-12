//
//  DetailsPopupView.swift
//  Branch Monster Factory
//
//  Created by Robert Gioia on 11/6/25.
//

import SwiftUI
import BranchSDK

struct DetailsPopupView: View {
    let eventData: BranchEvent
    let monsterName: String

    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack(spacing: 15) {
                    Text("Branch Event Data")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.top, 5)
                        .font(
                            Font.custom("IBMPlexSans-Regular", size: 18, relativeTo: .body)
                        )
                    
                    Text("Monster Name: \(monsterName)")
                        .font(.subheadline)
                        .foregroundColor(.white)
                        .padding(.top, 5)
                        .font(
                            Font.custom("IBMPlexSans-Regular", size: 18, relativeTo: .body)
                        )
                    
                    Text("Monster Level: \(eventData.customData["Monster Level"] ?? "")")
                        .font(.subheadline)
                        .foregroundColor(.white)
                        .padding(.top, 5)
                        .font(
                            Font.custom("IBMPlexSans-Regular", size: 18, relativeTo: .body)
                        )
                    
                    Text("Monster Color: \(eventData.customData["Monster Color"] ?? "")")
                        .font(.subheadline)
                        .foregroundColor(.white)
                        .padding(.top, 5)
                        .font(
                            Font.custom("IBMPlexSans-Regular", size: 18, relativeTo: .body)
                        )
                    
                    Text("Monster Exp: \(eventData.customData["Monster Exp"] ?? "")")
                        .font(.subheadline)
                        .foregroundColor(.white)
                        .padding(.top, 5)
                        .font(
                            Font.custom("IBMPlexSans-Regular", size: 18, relativeTo: .body)
                        )
                    
                    Text("Tap anywhere to close")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .font(
                            Font.custom("IBMPlexSans-Regular", size: 18, relativeTo: .body)
                        )
                }
                .padding(30)
                .frame(maxWidth: 300)
                .background(Color.black)
                .cornerRadius(12)
                .shadow(radius: 10)
            }.background(Color.black)
        }
    }
}
