//
//  Placeholders.swift
//
//  Template by Pete Maiser, January 2025 through May 2025
//      made availble here:
//      https://github.com/fastfiveproducts/template.ios
//      per terms of the MIT License
//
//  This particular implementation is for:
//      APP_NAME
//      DATE
//      YOUR_NAME
//


import Foundation

let placeholderUUID = UUID(uuidString: "00000000-0000-0000-0000-000000000000")!

extension Announcement {
    static let placeholder = Announcement(
        id: 0,
        title: "",
        content: "Announcements not available!",
        displayStartDate: Date(),
        displayEndDate: Date()
    )
}
