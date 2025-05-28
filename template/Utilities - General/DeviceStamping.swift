//
//  DeviceStamping.swift
//
//  Created by Pete Maiser, January 2025 through May 2025
//      made availble here:
//      https://github.com/fastfiveproducts/template.ios
//      per terms of the MIT License
//      changes should be rare; it is recommended changes are applied to the template
//      and the entire file compared-and-then-replaced here if/as appropriate
//


import Foundation
import UIKit

func deviceIdentifierstamp() -> String {
    return UIDevice.current.identifierForVendor?.uuidString ?? "device stamp failed"
    
    // TODO: if this function is used, the Privacy Statement must tell users we record an identifier from their device
}

func deviceTimestamp() -> String {
    return Date().description
}
