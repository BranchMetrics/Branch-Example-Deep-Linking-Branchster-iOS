//
//  LinkPopupView.swift
//  Branch Monster Factory
//
//  Created by Curtis Wang on 11/6/25.
//

import SwiftUI

struct LinkPopupView: View {
    let link: String

    var body: some View {
        VStack(spacing: 15) {
            
            Image(systemName: "link.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .foregroundColor(.green)
                .shadow(radius: 10)
            
            Text(link)
                .font(.callout)
                .lineLimit(3)
                .multilineTextAlignment(.center)
                .truncationMode(.middle)
                .padding(8)
                .background(Color.gray.opacity(0.3))
                .cornerRadius(5)
                .foregroundColor(.white)
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
        .frame(maxWidth: 300)
    }
}
