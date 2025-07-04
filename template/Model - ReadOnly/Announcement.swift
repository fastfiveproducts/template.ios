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

    // to conform to Listable, use known data to describe the object
    var objectDescription: String { content }
}

extension Announcement {
    static let usePlaceholder = false
    static let placeholder = Announcement(
        id: 0,
        title: "",
        content: "Announcements not available!",
        displayStartDate: Date(),
        displayEndDate: Date()
    )
}
