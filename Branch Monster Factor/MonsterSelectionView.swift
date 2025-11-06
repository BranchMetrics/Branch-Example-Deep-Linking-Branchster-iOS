//
//  MonsterSelectionView.swift
//  Branch Monster Factory
//
//  Created by Robert Gioia on 11/5/25.
//

import SwiftUI

struct MonsterSectionView: View {
    let monsterIconName: String
    let progressRatio: Double
    let xpLabel: String
    
    @Environment(AppNavigation.self) private var nav: AppNavigation
    
    var body: some View {
        VStack {
            Image(monsterIconName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 300, height: 300)
                .clipShape(Circle())
                .shadow(radius: 10)
                .transition(.rotationFlip)
                .animation(.spring(response: 0.5, dampingFraction: 0.5, blendDuration: 0.5), value: nav.monsterLevel)
                .id(nav.monsterLevel)
                .overlay(
                    Circle()
                        .fill(nav.showEvolutionFlash ? Color.white.opacity(0.8) : Color.clear)
                        .frame(width: 350, height: 350)
                        .scaleEffect(nav.showEvolutionFlash ? 1.0 : 0.0)
                        .animation(.easeOut(duration: 0.2), value: nav.showEvolutionFlash)
                )
            
            HStack {
                ProgressView("Level \(nav.monsterLevel)", value: progressRatio, total: 1.0)
                    .progressViewStyle(.linear)
                    .tint(.pink)
                    .foregroundColor(.white)
                
                Text(xpLabel)
                    .foregroundColor(.white)
                    .font(.caption)
            }
            .padding()
        }
        .border(.white, width: 2)
        .padding()
    }
}
