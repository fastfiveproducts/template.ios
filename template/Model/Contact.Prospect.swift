//
//  Contact.Prospect.swift
//      Template v0.1.3
//      © Fast Five Products LLC, 2025
//      https://github.com/fastfiveproducts/template.ios
//      used here per terms of template.ios License file
//
//  This particular implementation is for:
//      APP_NAME
//      started from template 20YY-MM-DD
//      modifications cannot be used or copied without permission from YOUR_NAME
//
//  READ and Delete when using template:
//
//     Contact.Customer: is a sample of a struct that is used in the app
//     and persisted via the Cloud use Firebase Data Connect.
//
//     Contact.Friend: is a sample of a class that is used in the app
//     and persisted locally using SwiftData.
//
//     Contact.Prospect: is a sample of a struct that is used in the app
//     and persisted locally using FileManager
//
//     Also note other examples/samples:
//     "Annoucement" in this app is ready-only and sourced from Firebase Firestore
//     "User" in this app is a mix of Firebase Authentication and Firebase Data Connect
//     "Post" in this app is read-write and stored via Firebase Data Connect
//


import Foundation

// Prospect - example of data that may be sent to the cloud in the future or may not
// so for example's sake, we will store these via a file structure

struct Prospect: Listable {   
    var id = UUID()

    // attributes
    var firstName: String
    var lastName: String
    var percent: Int
    var contact: String
    var timestamp: Date
        
    init(firstName: String, lastName: String, percent: Int = 50, contact: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.percent = percent
        self.contact = contact
        self.timestamp = Date()
    }
    
    // to conform to Listable, use known data to describe the object
    var objectDescription: String {
        "Prospect (\(percent)%):  \(firstName) \(lastName)"
    }
    
    var isValid: Bool {
        !firstName.trimmingCharacters(in: .whitespaces).isEmpty &&
        !lastName.trimmingCharacters(in: .whitespaces).isEmpty
    }
}

extension Prospect {
    static var empty: Prospect {
        Prospect(firstName: "", lastName: "", contact: "")
    }
    
    static let usePlaceholder = false
    static var placeholder: Prospect {
        Prospect(firstName: "first_name", lastName: "last_name", contact: "firstname@lastname.com")
    }
}

#if DEBUG
extension Prospect {
    static let testObjects: [Prospect] = [
        Prospect(firstName: "SideShow", lastName: "Bob", percent: 75, contact: "bob@smsp.gov"),
        Prospect(firstName: "Groundskeeper", lastName: "Willie", contact: "bigred@springfieldelemetary.edu"),
        Prospect(firstName: "Seymour", lastName: "Skinner", percent: 25, contact: "principle@springfieldelemetary.edu")
    ]
}
#endif
