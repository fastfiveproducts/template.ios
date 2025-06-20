//
//  SampleLocalStruct.swift
//
//  Template by Pete Maiser, July 2024 through June 2025
//      Template v0.1.2 (June)
//      © Fast Five Products LLC, 2025
//      https://github.com/fastfiveproducts/template.ios
//      used here per terms of the MIT License
//
//  This particular implementation is for:
//      APP_NAME
//      started from template 20YY-MM-DD
//      modifications cannot be used or copied without permission from YOUR_NAME
//


import Foundation

struct SampleLocalStruct: Identifiable, Equatable, Codable {
    var id = UUID()
    var paswordHint: String
    var favoriteColor: String
    var dogName: String
    
    var isValid: Bool { !favoriteColor.isEmpty && !dogName.isEmpty }
}
