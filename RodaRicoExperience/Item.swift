//
//  Item.swift
//  RodaRicoExperience
//
//  Created by Matheus Silva on 12/08/25.
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
