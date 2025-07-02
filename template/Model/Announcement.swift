//
//  Announcement.swift
//
//  Template created by Pete Maiser, July 2024 through May 2025
//      © Fast Five Products LLC, 2025
//      https://github.com/fastfiveproducts/template.ios
//      made available, and used here, per terms of the MIT License
//      changes should be rare; it is recommended changes are applied to the template
//      and the entire file compared-and-then-replaced here if/as appropriate
//
//      Template v0.1.1
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
    // to conform to Listable, add placeholder features
    static let usePlaceholder = false
    static let placeholder = Announcement(
        id: 0,
        title: "",
        content: "Announcements not available!",
        displayStartDate: Date(),
        displayEndDate: Date()
    )
}
