//
//  DetailsPopupView.swift
//  Branch Monster Factory
//
//  Created by Robert Gioia on 11/6/25.
//

import SwiftUI

struct DetailsPopupView: View {

    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 15) {
                Text("Branch Event Data")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.top, 5)
                    
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
