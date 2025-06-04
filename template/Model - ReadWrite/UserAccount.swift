//
//  UserAccount.swift
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

// Auth Service Data
struct UserAuth: Equatable, Codable {
    let uid: String
    var email: String
    var phoneNumber: String?
}

// User Profile Data
struct UserProfile: Equatable, Codable {
    let uid: String
    let displayName: String
    let photoUrl: String
    var isValid: Bool { !uid.isEmpty && !displayName.isEmpty }
}

// Helper-key for User Reference
struct UserKey: Equatable, Codable {
    let uid: String
    let displayName: String
    var isValid: Bool {
        !uid.isEmpty &&
        !displayName.isEmpty }
}

// Overall User Account
struct UserAccount: Equatable, Codable {
    var email: String
    var phoneNumber: String?
    var profile: UserProfile
    var userKey: UserKey { UserKey(uid: profile.uid, displayName: profile.displayName) }
}

// used to create or update a User:
//struct UserCandidate {
//    let email: String
//    let password: String
//    let phoneNumber: String
//    let displayName: String
//    var isValid: Bool {
//        !email.isEmpty &&
//        !phoneNumber.isEmpty &&
//        !displayName.isEmpty
//    }
//}

// used to create or update a User Profile:
struct UserProfileCandidate {
    let uid: String
    let displayName: String
    let photoUrl: String
    var isValid: Bool { !uid.isEmpty && !displayName.isEmpty }
}

extension UserAccount {
    static let blankUser = UserAccount(email: "", phoneNumber: "", profile: UserProfile.blankUser)
}

extension UserAuth {
    static let blankUser = UserAuth(uid: "", email: "", phoneNumber: "")
}

extension UserKey {
    static let blankUser = UserKey(uid: "", displayName: "")
}

extension UserProfile {
    static let blankUser = UserProfile(uid: "", displayName: "", photoUrl: "")
}
