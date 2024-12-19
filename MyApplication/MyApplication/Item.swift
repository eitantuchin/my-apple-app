//
//  Item.swift
//  MyApplication
//
//  Created by Eitan Tuchin on 12/19/24.
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
