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
    var event: String
    var timestamp: Date
    
    init(_ event: String, timestamp: Date = Date()) {
        self.event = event
        self.timestamp = timestamp
    }
}
