//
//  Announcement.swift
//
//  Created by Pete Maiser, January 2025 through May 2025
//      made availble here:
//      https://github.com/fastfiveproducts/template.ios
//      per terms of the MIT License
//      changes should be rare; it is recommended changes are applied to the template
//      and the entire file compared-and-then-replaced here if/as appropriate
//


import Foundation

struct Announcement: Listable {
    let id: Int
    let title: String
    let content: String
    let displayStartDate: Date
    let displayEndDate: Date
    private(set) var imageUrl: String?
    
    static let typeDescription = "Announcement"
    var objectDescription: String { content }
}
