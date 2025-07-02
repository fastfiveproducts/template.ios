//
//  TestObjectExtensions.swift
//
//  Template by Pete Maiser, July 2024 through May 2025
//      Template v0.1.2 (renamed from TestDataLocal)
//      © Fast Five Products LLC, 2025
//      https://github.com/fastfiveproducts/template.ios
//      used here per terms of the MIT License
//
//  This particular implementation is for:
//      APP_NAME
//      started from template 20YY-MM-DD
//      modifications cannot be used or copied without permission from YOUR_NAME
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
        displayStartDate: Calendar.current.date(byAdding: .day, value: -2, to: Date())!,
        displayEndDate: Calendar.current.date(byAdding: .day, value: 364, to: Date())!
    )
    static let testObjectAnother = Announcement(
        id: 202502281200,
        title: "Another Lorem Ipsum Title",
        content: "Another announcement content lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
        displayStartDate: Calendar.current.date(byAdding: .day, value: -1, to: Date())!,
        displayEndDate: Calendar.current.date(byAdding: .day, value: 365, to: Date())!
    )
    static let testObjects: [Announcement] = [.testObject, .testObjectAnother]
}

extension User {
    static let testObject = User(auth: UserAuth.testObject, account: UserAccount.testObject)
    static let testObjectAnother = User(auth: UserAuth.testObjectAnother, account: UserAccount.testObjectAnother)
    static let testObjects: [User] = [.testObject, .testObjectAnother]
}

extension UserAuth {
    static let testObject = UserAuth(uid: UserKey.testObject.uid, email: "lorem@ipsum.com", phoneNumber: "+5555550101")
    static let testObjectAnother = UserAuth(uid: UserKey.testObjectAnother.uid, email: "alorem@ipsum.com", phoneNumber: "+5555550102")
    static let testObjects: [UserAuth] = [.testObject, .testObjectAnother]
}

extension UserAccount {
    static let testObject = UserAccount(
        uid: UserKey.testObject.uid,
        displayName: UserKey.testObject.displayName,
        photoUrl: "larryipsum.photo.com")
    static let testObjectAnother = UserAccount(
        uid: UserKey.testObjectAnother.uid,
        displayName: UserKey.testObjectAnother.displayName,
        photoUrl: "alisonipsum.photo.com")
    static let testObjects: [UserAccount] = [.testObject, .testObjectAnother]
}

extension UserKey {
    static let testObject = UserKey(uid: "00000000-0000-0000-0000-000000000001", displayName: "Larry Ipsum")
    static let testObjectAnother = UserKey(uid: "00000000-0000-0000-0000-000000000002", displayName: "Alison Loretta Ipsum")
    static let testObjects: [UserKey] = [.testObject, .testObjectAnother]
}

extension PrivateMessage {
    static let testObject = PrivateMessage(
        id: UUID(),
        timestamp: Date(),
        from: UserKey.testObject,
        to: UserKey.testObjectAnother,
        title: "Title Lorem Ipsum",
        content: "Test Message from tO to tOA, lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
    )
    static let testObjectAnother = PrivateMessage(
        id: UUID(),
        timestamp: Date(),
        from: UserKey.testObjectAnother,
        to: UserKey.testObject,
        title: "Another Title Lorem ipsum",
        content: "Test Message from tOA  to tO, more Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
    )
    static let testObjectTiny = PrivateMessage(
        id: UUID(),
        timestamp: Date(),
        from: UserKey.testObject,
        to: UserKey.testObjectAnother,
        title: "t",
        content: "tO to tOA"
    )
    static let testObjects: [PrivateMessage] = [.testObject, .testObjectAnother, .testObjectTiny]
}

extension PublicComment {
    static let testObject = PublicComment(
        id: UUID(),
        timestamp: Date(),
        from: UserKey.testObject,
        to: UserKey.blankUser,
        title: "",
        content: "Test Comment from tO, lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
    )
    static let testObjectAnother = PublicComment(
        id: UUID(),
        timestamp: Date(),
        from: UserKey.testObjectAnother,
        to: UserKey.blankUser,
        title: "",
        content: "Test Comment from tOA, more lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
    )
    static let testObjectTiny = PublicComment(
        id: UUID(),
        timestamp: Date(),
        from: UserKey.testObject,
        to: UserKey.blankUser,
        title: "",
        content: "tO comment"
    )
    static let testObjects: [PublicComment] = [.testObject, .testObjectAnother, testObjectTiny]
}
    
#endif
