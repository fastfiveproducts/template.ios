//
//  Contact.Customer.swift
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

// Customer - example of data we would get from the cloud, and updates sent to cloud
// so for example's sake, these will be focused on easy synchronization with cloud APIs

struct Customer: Listable {
    var id = UUID()

    // attributes
    var firstName: String
    var lastName: String
    var isVIP: Bool
    var contact: String
    var timestamp: Date
    
    init(firstName: String, lastName: String, isVIP: Bool = false, contact: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.isVIP = isVIP
        self.contact = contact
        self.timestamp = Date()
    }
    
    // to conform to Listable, use known data to describe the object
    var objectDescription: String {
        isVIP ? "Customer (VIP):  \(firstName) \(lastName)" :
        "Customer:  \(firstName) \(lastName)"
    }
    
    var isValid: Bool {
        !firstName.trimmingCharacters(in: .whitespaces).isEmpty &&
        !lastName.trimmingCharacters(in: .whitespaces).isEmpty
    }
}

extension Customer {
    static var empty: Customer {
        Customer(firstName: "", lastName: "", contact: "")
    }
    
    static let usePlaceholder = false
    static var placeholder: Customer {
        Customer(firstName: "first_name", lastName: "last_name", contact: "firstname@lastname.com")
    }
}

#if DEBUG
extension Customer {
    static let testObjects: [Customer] = [
        Customer(firstName: "Moe", lastName: "Syzlak", contact: "764-555-8437"),
        Customer(firstName: "Ralph", lastName: "Wiggum", contact: "none"),
        Customer(firstName: "Bumblebee", lastName: "Man", isVIP: true, contact: "megusta@bumblebee.com")
    ]
}
#endif
