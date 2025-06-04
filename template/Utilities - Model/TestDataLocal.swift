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

extension Announcement {
    static let testObject = Announcement(
        id: 202501311200,
        title: "A Lorem Ipsum Title",
        content: "Announcement content lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
        displayStartDate: Calendar.current.date(byAdding: .day, value: -1, to: Date())!,
        displayEndDate: Calendar.current.date(byAdding: .day, value: 366, to: Date())!
    )
    static let testObjects: [Announcement] = [.testObject]
}


extension UserAccount {
    static let testObject = UserAccount(email: "lorem@ipsum.com", phoneNumber: "+5555550101", profile: UserProfile.testObject)
    static let testObjectAnother = UserAccount(email: "alorem@ipsum.com", phoneNumber: "+5555550102", profile: UserProfile.testObjectAnother)
    static let testObjects: [UserAccount] = [.testObject, .testObjectAnother]
}

extension UserAuth {
    static let testObject = UserAuth(uid: "LIid", email: "lorem@ipsum.com", phoneNumber: "+5555550101")
    static let testObjects: [UserAuth] = [.testObject]
}

extension UserProfile {
    static let testObject = UserProfile(
        uid: "LIid",
        displayName: "Larry Ipsum",
        photoUrl: "larryipsum.photo.com")
    static let testObjectAnother = UserProfile(
        uid: "ALIid",
        displayName: "Alison Loretta Ipsum",
        photoUrl: "alisonipsum.photo.com")
    static let testObjects: [UserProfile] = [.testObject, .testObjectAnother]
}

extension PrivateMessage {
    static let testObject = PrivateMessage(
        id: UUID(),
        timestamp: Date(),
        from: UserAccount.testObject.userKey,
        to: UserAccount.testObjectAnother.userKey,
        title: "Title Lorem Ipsum",
        content: "Test Message from tO to tOA, lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
    )
    static let testObjectAnother = PrivateMessage(
        id: UUID(),
        timestamp: Date(),
        from: UserAccount.testObjectAnother.userKey,
        to: UserAccount.testObject.userKey,
        title: "Another Title Lorem ipsum",
        content: "Test Message from tOA  to tO, more Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
    )
    static let testObjects: [PrivateMessage] = [.testObject, .testObjectAnother]
}

extension PublicComment {
    static let testObject = PublicComment(
        id: UUID(),
        timestamp: Date(),
        from: UserAccount.testObject.userKey,
        to: UserAccount.blankUser.userKey,
        title: "",
        content: "Test Comment from tO, lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
    )
    static let testObjectAnother = PublicComment(
        id: UUID(),
        timestamp: Date(),
        from: UserAccount.testObjectAnother.userKey,
        to: UserAccount.blankUser.userKey,
        title: "",
        content: "Test Comment from tOA, more lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
    )
    static let testObjects: [PublicComment] = [.testObject, .testObjectAnother]
}
    
#endif
