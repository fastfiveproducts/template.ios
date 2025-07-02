//
//  ObjectSample.swift
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

//  READ and Delete when using template:
//
//     StructSample: is a sample of a struct that is then later used in the app
//     and persisted locally using FileManager
//
//     ObjectSample: is a sample of a class that is then later used in the app
//     and persisted locally using SwiftData
//
//     Also note other examples/samples:
//     "Annoucement" in this app is ready-only and sourced from Firebase Firestore
//     "User" in this app is a mix of Firebase Authentication and Firebase Data Connect
//     "Post" in this app is read-write and stored via Firebase Data Connect
//


import Foundation
import SwiftData

@Model
class ObjectSample {
    @Attribute var paswordHint: String
    @Attribute var favoriteColor: String
    @Attribute var dogName: String

    init(paswordHint: String, favoriteColor: String, dogName: String) {
        self.paswordHint = paswordHint
        self.favoriteColor = favoriteColor
        self.dogName = dogName
    }

    var isValid: Bool {
        !favoriteColor.isEmpty && !dogName.isEmpty
    }
}
