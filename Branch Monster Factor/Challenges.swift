//
//  Challenges.swift
//  Branch Monster Factory
//
//  Created by Robert Gioia on 11/5/25.
//

final class Challenges {

    static let shared = Challenges()

    private init() {}

    private let listOfChallenges: [String: [String]] = [
        "Create Branch Link": [
            "Generate a link to earn some XP for your monster"
        ],
        "Share Branch Link": ["Share a link to earn some XP for your monster"],
        "Trigger Branch Event": [
            "Trigger an event to earn some XP for your monster"
        ],
        "View Branch Event Data": [
            "View event data to earn some XP for your monster"
        ],
        "Generate Branch QR Code": [
            "Generate QR code to earn some XP for your monster"
        ],
        "Share Branch QR Code": [
            "Share QR code to earn some XP for your monster"
        ],
    ]

    var allChallenges: [(title: String, description: [String])] {
        return listOfChallenges.map { (key: $0.key, description: $0.value) }
            .sorted { $0.title < $1.title }
    }
}
