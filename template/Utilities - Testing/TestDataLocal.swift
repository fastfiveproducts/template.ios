//
//  TestDataLocal.swift
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

#if DEBUG

var isPreview: Bool {
    return ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
}
var isPreviewTestData: Bool = false

extension Announcement {
    static let testAnnouncement = Announcement(
        id: 1,
        title: "Lorem ipsum",
        content: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
        displayStartDate: Calendar.current.date(byAdding: .day, value: -1, to: Date())!,
        displayEndDate: Calendar.current.date(byAdding: .day, value: 366, to: Date())!
    )
    static let testAnnouncements: [Announcement] = [.testAnnouncement]
}


extension User {
    static let testUser = User(email: "lorem@ipsum.com", phoneNumber: "+5555550101", profile: UserProfile.testUser)
    static let testUserAnother = User(email: "alorem@ipsum.com", phoneNumber: "+5555550102", profile: UserProfile.testUserAnother)
}

extension UserAuth {
    static let testUser = UserAuth(uid: "LIid", email: "lorem@ipsum.com", phoneNumber: "+5555550101")
}

extension UserProfile {
    static let testUser = UserProfile(
        uid: "LIid",
        updateDeviceStamp: "test iphone",
        updateDeviceTimestamp: "testDeviceTimestamp",
        createUserEmail: "lorem@ipsum.com",
        displayName: "Lorem Ipsum",
        photoUrl: "loremipsum.com")
    static let testUserAnother = UserProfile(
        uid: "ALIid",
        updateDeviceStamp: "test iphone",
        updateDeviceTimestamp: "testDeviceTimestamp",
        createUserEmail: "alorem@ipsum.com",
        displayName: "Another Lorem Ipsum",
        photoUrl: "loremipsum.com",
        settingsString: "ipsum")
}

extension PrivateMessage {
    static let testMessage = PrivateMessage(
        id: UUID(),
        timestamp: Date(),
        status: .sent,
        from: User.testUser.userKey,
        to: User.testUserAnother.userKey,
        title: "Lorem ipsum",
        content: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
    )
    static let testMessageAnother = PrivateMessage(
        id: UUID(),
        timestamp: Date(),
        status: .sent,
        from: User.testUserAnother.userKey,
        to: User.testUser.userKey,
        title: "Another Lorem ipsum",
        content: "More Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
    )
    static let testMessages: [PrivateMessage] = [.testMessage, .testMessageAnother]
}

extension PublicComment {
    static let testComment = PublicComment(
        id: UUID(),
        timestamp: Date(),
        from: User.testUser.userKey,
        to: User.testUserAnother.userKey,
        title: "Lorem ipsum",
        content: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
    )
    static let testComments: [PublicComment] = [.testComment]
}
    
#endif
