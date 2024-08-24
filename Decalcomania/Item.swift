//
//  Item.swift
//  Decalcomania
//
//  Created by 장은석 on 8/24/24.
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
