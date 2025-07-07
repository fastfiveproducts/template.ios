//
//  ActivityLogEntry.swift
//  template
//
//  Created by Elizabeth Maiser on 7/5/25.
//

import Foundation
import SwiftData

@Model
final class ActivityLogEntry {
    var timestamp: Date
    var event: String
    
    init(timestamp: Date, event: String) {
        self.timestamp = timestamp
        self.event = event
    }
}
