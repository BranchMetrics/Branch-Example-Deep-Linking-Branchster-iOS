//
//  MonsterSelectionView.swift
//  Branch Monster Factory
//
//  Created by Robert Gioia on 11/5/25.
//

import SwiftUI

/*
    The view of a monster, its level, and its EXP
 */

struct MonsterView: View {
    let monsterIconName: String
    let progressRatio: Double
    let xpLabel: String
    
    @Environment(MonsterProgress.self) private var progress: MonsterProgress
    
    var body: some View {
        VStack {
            Image(monsterIconName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 300, height: 300)
                .clipShape(Circle())
                .shadow(radius: 10)
                .transition(.rotationFlip)
                .animation(.spring(response: 0.5, dampingFraction: 0.5, blendDuration: 0.5), value: progress.monsterLevel)
                .id(progress.monsterLevel)
                .overlay(
                    Circle()
                        .fill(progress.showEvolutionFlash ? Color.white.opacity(0.8) : Color.clear)
                        .frame(width: 350, height: 350)
                        .scaleEffect(progress.showEvolutionFlash ? 1.0 : 0.0)
                        .animation(.easeOut(duration: 0.2), value: progress.showEvolutionFlash)
                )
            
            HStack {
                ProgressView("Level \(progress.monsterLevel)", value: progressRatio, total: 1.0)
                    .progressViewStyle(.linear)
                    .tint(.purple)
                    .foregroundColor(.white)
                
                Text(xpLabel)
                    .foregroundColor(.white)
                    .font(.caption)
                    .font(
                        Font.custom("IBMPlexSans-Regular", size: 18, relativeTo: .body)
                    )
            }
            .padding()
        }
        .border(.white, width: 2)
        .padding()
    }
}
