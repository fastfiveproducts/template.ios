//
//  TemplateObject.swift
//
//  Template by Pete Maiser, July 2024 through July 2025
//      Template v0.1.2 (July)
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
//     TemplateStruct: is a sample of a struct that is then later used in the app
//     and persisted locally using FileManager
//
//     TemplateObject: is a sample of a class that is then later used in the app
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
class TemplateObject /* : Listable */ {
    var id = UUID()
    @Attribute var passwordHint: String
    @Attribute var favoriteColor: String
    @Attribute var dogName: String

    init(passwordHint: String, favoriteColor: String, dogName: String) {
        self.passwordHint = passwordHint
        self.favoriteColor = favoriteColor
        self.dogName = dogName
    }
    
    // to conform to Listable, use known data to describe the object
    var objectDescription: String {
        "Favorite Color: \(favoriteColor), Dog Name: \(dogName)"
    }

    var isValid: Bool {
        !favoriteColor.isEmpty && !dogName.isEmpty
    }
}

extension TemplateObject {
    static var usePlaceholder: Bool { false }
    static var placeholder = TemplateObject(passwordHint: "", favoriteColor: "", dogName: "")
}


#if DEBUG
extension TemplateObject {
    static let testObject = TemplateObject(
        passwordHint: "Sunshine",
        favoriteColor: "Blue",
        dogName: "Daisy"
    )
}
#endif
