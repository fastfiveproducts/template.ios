//
//  StructSample.swift
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

struct StructSample: Listable {
    var id = UUID()
    var passwordHint: String
    var favoriteColor: String
    var dogName: String

    // to conform to Listable, use known data to describe the object
    var objectDescription: String {
        "Favorite Color: \(favoriteColor), Dog Name: \(dogName)"
    }
    
    var isValid: Bool { !favoriteColor.isEmpty && !dogName.isEmpty }
}

extension StructSample {
    static var usePlaceholder: Bool { false }
    static var placeholder: StructSample { .init(passwordHint: "", favoriteColor: "", dogName: "") }

}

extension FormCaptureViewModel where T == StructSample {
    static func configured() -> FormCaptureViewModel<T> {
        FormCaptureViewModel(
            title: "Sample Form",
            fields: [
                PasswordHintField(),
                FavoriteColorField(),
                DogNameField()
            ],
            makeCaptured: { fields in
                StructSample(
                    passwordHint: fields[0].text,
                    favoriteColor: fields[1].text,
                    dogName: fields[2].text
                )
            }
        )
    }
}

struct PasswordHintField: Capturable {
    var labelText: String = "password hint"
    var promptText: String = "optional: Password Hint"
    var text: String = ""
    var required: Bool { false }
    var checkRestrictedWordList: Bool { false }
    var autoCapitalize: Bool { false }
}

struct FavoriteColorField: Capturable {
    var labelText: String = "favorite color"
    var promptText: String = "required: Favorite Color"
    var text: String = ""
}

struct DogNameField: Capturable {
    var labelText: String = "dog name"
    var promptText: String = "required: Your Dog's Name"
    var text: String = ""
}


extension StructSample {
    static let testObject = StructSample(
        passwordHint: "Sunshine",
        favoriteColor: "Blue",
        dogName: "Daisy"
    )
}
