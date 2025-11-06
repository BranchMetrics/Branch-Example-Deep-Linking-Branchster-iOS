//
//  LinkPopupView.swift
//  Branch Monster Factory
//
//  Created by Curtis Wang on 11/6/25.
//

import SwiftUI

struct LinkPopupView: View {
    // We pass the generated URL string into the view
    let link: String

    var body: some View {
        VStack(spacing: 15) {
            
            // Replaced the QR Code Image with a visual indicator icon
            Image(systemName: "link.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .foregroundColor(.green)
                .shadow(radius: 10)
            
            // Display the generated link
            Text(link)
                .font(.callout)
                // Restrict the link to a few lines to fit the popup
                .lineLimit(3)
                .multilineTextAlignment(.center)
                .truncationMode(.middle)
                .padding(8)
                .background(Color.gray.opacity(0.3))
                .cornerRadius(5)
                .foregroundColor(.white)
                // Crucial: Allow the user to long-press and copy the link
                .textSelection(.enabled)
            
            Text("Link Created! Tap on the link above to copy it.")
                .font(.subheadline)
                .foregroundColor(.white)
                .padding(.top, 5)
            
            Text("Tap anywhere to close")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding(30)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.black.opacity(0.85))
                .shadow(radius: 20)
        )
        // Match the width constraint of the QR code view
        .frame(maxWidth: 300)
    }
}
