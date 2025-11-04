//
//  Item.swift
//  Branch Monster Factor
//
//  Created by Guru Prasadh on 05/11/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
