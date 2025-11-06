//
//  Challenges.swift
//  Branch Monster Factory
//
//  Created by Robert Gioia on 11/5/25.
//

import Foundation

/*
    Defines the challenges which allow the user to earn EXP
 */
final class Challenges {
    static let shared = Challenges()

    private init() {}

    // Refactored to store a tuple: (description, imageName)
    private let rawChallenges: [String: (description: String, imageName: String)] = [
        "Create Branch Link": (
            description: "Generate a link to earn some XP for your monster",
            imageName: "link"
        ),
        "Share Branch Link": (
            description: "Share a link to earn some XP for your monster",
            imageName: "upload"
        ),
        "Trigger Branch Event": (
            description: "Trigger an event to earn some XP for your monster",
            imageName: "activity"
        ),
        "View Branch Event Data": (
            description: "View event data to earn some XP for your monster",
            imageName: "braces"
        ),
        "Generate Branch QR Code": (
            description: "Generate QR code to earn some XP for your monster",
            imageName: "qr-code"
        ),
        "Share Branch QR Code": (
            description: "Share QR code to earn some XP for your monster",
            imageName: "upload"
        ),
    ]

    var allChallenges: [Challenge] {
        return rawChallenges.map { key, value in
            Challenge(
                title: key,
                description: value.description,
                imageName: value.imageName
            )
        }
        .sorted { $0.title < $1.title }
    }
}
