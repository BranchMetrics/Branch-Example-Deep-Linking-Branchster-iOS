//
//  QRCodePopupView.swift
//  Branch Monster Factory
//
//  Created by Robert Gioia on 11/5/25.
//

import SwiftUI

struct QRCodePopupView: View {
    let image: UIImage

    var body: some View {
        VStack(spacing: 15) {
            Image(uiImage: image)
                .resizable()
                .interpolation(.none)
                .scaledToFit()
                .frame(width: 200, height: 200)
                .shadow(radius: 10)
            
            Text("Here is your Branch QR code!")
                .font(.headline)
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
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.black.opacity(0.85))
                .shadow(radius: 20)
        )
        .frame(maxWidth: 300)
    }
}
