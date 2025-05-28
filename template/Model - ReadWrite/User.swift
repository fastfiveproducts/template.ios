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

struct User: Equatable, Codable {
    var email: String
    var phoneNumber: String?
    var profile: UserProfile
    var userKey: UserKey { UserKey(uid: profile.uid, displayName: profile.displayName) }
}

struct UserAuth: Equatable, Codable {
    let uid: String
    var email: String
    var phoneNumber: String?
}

struct UserKey: Equatable, Codable {
    let uid: String
    let displayName: String
    var isValid: Bool {
        !uid.isEmpty &&
        !displayName.isEmpty }
}

// used to create or update a User:
struct UserCandidate {
    let email: String
    let phoneNumber: String
    let displayName: String
    var isValid: Bool {
        !email.isEmpty &&
        !phoneNumber.isEmpty &&
        !displayName.isEmpty
    }
}

struct UserProfile: Equatable, Codable {
    private(set) var id: UUID?
    let uid: String
    private(set) var createTimestamp: Date?
    let updateDeviceStamp: String
    let updateDeviceTimestamp: String
    let createUserEmail: String
    let displayName: String
    private(set) var photoUrl: String?
    private(set) var settingsString: String?
    var isValid: Bool { !uid.isEmpty && !displayName.isEmpty }
}

// used to create or update a User Profile:
struct UserProfileCandidate {
    private(set) var id: UUID?
    let uid: String
    var updateDeviceStamp: String
    var updateDeviceTimestamp: String
    var createUserEmail: String
    var displayName: String
    var photoUrl: String?
    var settingsString: String?
    var isValid: Bool { !uid.isEmpty && !displayName.isEmpty }
}

extension User {
    static let blankUser = User(email: "", phoneNumber: "", profile: UserProfile.blankUser)
}

extension UserAuth {
    static let blankUser = UserAuth(uid: "", email: "", phoneNumber: "")
}

extension UserProfile {
    static let blankUser = UserProfile(uid: "", updateDeviceStamp: "", updateDeviceTimestamp: "", createUserEmail: "", displayName: "")
}
