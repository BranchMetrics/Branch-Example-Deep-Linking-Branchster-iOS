//
//  ViewModifiers.swift
//  Branch Monster Factory
//
//  Created by Robert Gioia on 11/5/25.
//

import SwiftUI

/*
    Utilities for the monster level up animation
 */

struct Rotation3DModifier: ViewModifier {
    let angle: Angle

    func body(content: Content) -> some View {
        content.rotation3DEffect(angle, axis: (x: 0, y: 1, z: 0))
    }
}

extension AnyTransition {
    private static func flipRotation(angle: Angle) -> AnyTransition {
        return .scale(scale: 0.5)
            .combined(with: .opacity)
            .combined(with: .modifier(
                active: Rotation3DModifier(angle: angle),
                identity: Rotation3DModifier(angle: .degrees(0))
            ))
    }
    
    static var rotationFlip: AnyTransition {
        .asymmetric(
            insertion: flipRotation(angle: .degrees(180)),
            removal: flipRotation(angle: .degrees(-180))
        )
    }
}
