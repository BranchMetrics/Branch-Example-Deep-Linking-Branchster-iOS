//
//  DataModules.swift
//  Branch Monster Factory
//
//  Created by Robert Gioia on 11/5/25.
//

import Foundation

/*
    Structs that hold some data
 */

struct OnboardingStep: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let imageName: String
}

struct Challenge {
    let title: String
    let description: String
    let imageName: String
}
