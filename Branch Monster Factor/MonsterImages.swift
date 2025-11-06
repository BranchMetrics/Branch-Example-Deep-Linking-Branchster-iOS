//
//  MonsterImages.swift
//  Branch Monster Factory
//
//  Created by Robert Gioia on 11/5/25.
//

import Foundation

/*
    Contains the names of the monster images and references
 */

final class MonsterImages {
    static let shared = MonsterImages()
    private init() {}

    let monsterAssets: [String: [String]] = [
        "green": ["green_monster_level_1", "green_monster_level_2", "green_monster_level_3", "green_monster_level_4"],
        "red": ["red_monster_level_1", "red_monster_level_2", "red_monster_level_3", "red_monster_level_4"],
        "blue": ["blue_monster_level_1", "blue_monster_level_2", "blue_monster_level_3", "blue_monster_level_4"],
        "yellow": ["yellow_monster_level_1", "yellow_monster_level_2", "yellow_monster_level_3", "yellow_monster_level_4"],
        "purple": ["purple_monster_level_1", "purple_monster_level_2", "purple_monster_level_3", "purple_monster_level_4"],
        "white": ["white_monster_level_1", "white_monster_level_2", "white_monster_level_3", "white_monster_level_4"],
        "black": ["black_monster_level_1", "black_monster_level_2", "black_monster_level_3", "black_monster_level_4"],
        "pink": ["pink_monster_level_1", "pink_monster_level_2", "pink_monster_level_3", "pink_monster_level_4"],
        "orange": ["orange_monster_level_1", "orange_monster_level_2", "orange_monster_level_3", "orange_monster_level_4"]
    ]
    
    let monsterNameMap: [String: String] = [
        "green": "Thorn Stalker",
        "red": "Rage Bastion",
        "blue": "Frost Wraith",
        "yellow": "Dusk Gleam",
        "purple": "Dream Serpent",
        "white": "Ice Revenant",
        "black": "Shadow Maw",
        "pink": "Bliss Warden",
        "orange": "Cinder Howl"
    ]

    func getThreeRandomLevel1Monsters(count: Int = 3) -> [String] {
        let allLevelOneMonsters: [String] = monsterAssets.values.compactMap { $0.first }
        let finalCount = min(count, allLevelOneMonsters.count)
        return Array(allLevelOneMonsters.shuffled().prefix(finalCount))
    }
}
