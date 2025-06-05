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
    var auth: UserAuth
    var profile: UserProfile
}

// used to create or update a User Profile:
struct UserProfileCandidate {
    let uid: String
    let displayName: String
    let photoUrl: String
    var isValid: Bool { !uid.isEmpty && !displayName.isEmpty }
}

extension UserKey {
    static let blankUser = UserKey(uid: "", displayName: "")
}

extension UserAuth {
    static let blankUser = UserAuth(uid: UserKey.blankUser.uid, email: "", phoneNumber: "")
}

extension UserProfile {
    static let blankUser = UserProfile(uid: UserKey.blankUser.uid, displayName: "", photoUrl: "")
}

extension UserAccount {
    static let blankUser = UserAccount(auth: UserAuth.blankUser, profile: UserProfile.blankUser)
}
