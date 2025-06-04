//
//  DebugLogging.swift
//
//  Created by Pete Maiser, January 2025 through May 2025
//      made availble here:
//      https://github.com/fastfiveproducts/template.ios
//      per terms of the MIT License
//      changes should be rare; it is recommended changes are applied to the template
//      and the entire file compared-and-then-replaced here if/as appropriate
//


import Foundation
import os.log

protocol DebugPrintable {}

extension DebugPrintable {
    static var debug: Bool {
        #if DEBUG
            return true
        #else
            return false
        #endif
    }
    
    func debugprint(_ str: String) {
        if Self.debug {
            print("\(String(describing: self.self)) \(str)")
        }
    }
}

func deviceLog(_ message: StaticString, category: String = "General", error: Error? = nil) {
    
    let bundleIdentifier: String = Bundle.main.bundleIdentifier ?? "unknownBundleId"
    let log = OSLog(subsystem: bundleIdentifier, category: category)
    
    if let error = error {
        os_log(.error, log: log, "%{public}@ %@", message as? CVarArg ?? "unknown log message", error.localizedDescription)
    } else {
        os_log(.error, log: log, "%{public}@", message as? CVarArg ?? "unknown log message")
    }
    
}
