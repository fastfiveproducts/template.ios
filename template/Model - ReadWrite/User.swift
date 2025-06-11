//
//  User.swift
//
//  Template by Pete Maiser, July 2024 through May 2025
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

// User
struct User: Equatable, Codable {
    var auth: UserAuth              // from the Authentication Service, masters users themselves (parent because it masters User Id)
    var account: UserAccount        // from the Application Data Service, masters data about users (child)
}

// Auth Service Data
struct UserAuth: Equatable, Codable {
    let uid: String                 // "User Id" is 'uid' to distinguish it from the UUI Application Ids
    var email: String
    var phoneNumber: String?
}

// User Account Data Service
struct UserAccount: Equatable, Codable {
    let uid: String                 // mastered by the Auth Service
    let displayName: String         // mastered by the Application Data Service
    let photoUrl: String
    var isValid: Bool { !uid.isEmpty && !displayName.isEmpty }
}

// Light, public, local-client helper-structure is most of the user data used throughout the app
struct UserKey: Equatable, Codable {
    let uid: String
    let displayName: String
    var isValid: Bool {
        !uid.isEmpty &&
        !displayName.isEmpty }
}

// used to create or update a User Account:
struct UserAccountCandidate {
    let uid: String
    let displayName: String
    let photoUrl: String
    var isValid: Bool { !uid.isEmpty && !displayName.isEmpty }
}

extension User {
    static let blankUser = User(auth: UserAuth.blankUser, account: UserAccount.blankUser)
}

extension UserAuth {
    static let blankUser = UserAuth(uid: UserKey.blankUser.uid, email: "", phoneNumber: "")
}

extension UserAccount {
    static let blankUser = UserAccount(uid: UserKey.blankUser.uid, displayName: "", photoUrl: "")
}

extension UserKey {
    static let blankUser = UserKey(uid: "", displayName: "")
}
