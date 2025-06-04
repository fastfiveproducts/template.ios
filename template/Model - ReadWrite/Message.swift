//
//  Message.swift
//
//  Created by Pete Maiser, January 2025 through May 2025
//      made availble here:
//      https://github.com/fastfiveproducts/template.ios
//      per terms of the MIT License
//      changes should be rare; it is recommended changes are applied to the template
//      and the entire file compared-and-then-replaced here if/as appropriate
//


import Foundation


// base message
protocol Message: Listable {
    var id: UUID { get }
    var timestamp: Date { get }
    var from: UserKey { get }
    var to: UserKey { get }
    var title: String { get }
    var content: String { get }
    var references: Set<UUID> { get }
    static var typeDisplayName: String { get }
}


// used to submit-send a Message:
struct MessageCandidate: DebugPrintable {
    let from: UserKey
    var to: UserKey
    var title: String
    var content: String
    var references: Set<UUID> = []
    
    var isValid: Bool {
        guard !content.isEmpty,
              from.isValid
        else {
            debugprint("validation failed.")
            return false
        }
        return true
    }
}


// optional reference to any other object:
struct MessageReference {
    let id: UUID
    let referenceId: UUID
    
    var isValid: Bool {
        id != referenceId
    }
}


// message search
extension Message {
    func contains(_ string: String) -> Bool {
        var properties = [title, content].map { $0.lowercased() }
        if !to.displayName.isEmpty {
            properties.append(to.displayName.lowercased())
        }
        if !from.displayName.isEmpty {
            properties.append(from.displayName.lowercased())
        }
        let query = string.lowercased()
        let matches = properties.filter { $0.contains(query) }
        return !matches.isEmpty
    }
}


// message view perspective
enum MessagePerspective { case
    comment,
    inbox,
    sent
}


// message subtype of "public comment" (one-to-everyone, public)
struct PublicComment: Message, Listable {
    private(set) var id: UUID
    private(set) var timestamp: Date
    let from: UserKey
    let to: UserKey
    let title: String
    let content: String
    var references: Set<UUID> = []
    
    // to conform to Message, establich a short displayable type description
    static let typeDisplayName: String = "Comment"
       
    // to conform to Listable, use known data to describe the object
    var objectDescription: String { "Comment from " + from.displayName + ": " + content }
    
    var isValid: Bool {
        guard !content.isEmpty,
              from.isValid
        else {
            debugprint("validation failed.")
            return false
        }
        return true
    }
}


// message subtype of "private message" (one-to-one, private)
struct PrivateMessage: Message, Listable  {
    private(set) var id: UUID
    private(set) var timestamp: Date
    let from: UserKey
    let to: UserKey
    let title: String
    let content: String
    var references: Set<UUID> = []
    var status: [MessageStatus] = []
    
    // to conform to Message, establich a short displayable type description
    static let typeDisplayName: String = "Message"
    
    // to conform to Listable, use known data to describe the object
    var objectDescription: String { "Message from " + from.displayName + ": " + content }
    
    var isValid: Bool {
        guard !title.isEmpty,
              !content.isEmpty,
              from.isValid,
              to.isValid
        else {
            debugprint("validation failed.")
            return false
        }
        return true
    }
}


// (private) message status
enum MessageStatusCode: String, Codable { case
    draft,
    sent,
    read,
    archived,
    deleted,
    error
}

struct MessageStatus: Codable, Hashable {
    private(set) var timestamp: Date?
    var uid: String!
    var status: MessageStatusCode
}


// placeholders
extension PublicComment {
    static let usePlaceholder = false
    static let placeholder = PublicComment(
        id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!,
        timestamp: Date(),
        from: UserKey.blankUser,
        to: UserKey.blankUser,
        title: "",
        content: "No Messages!"
    )
}

extension PrivateMessage {
    static let usePlaceholder = false
    static let placeholder = PrivateMessage(
        id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!,
        timestamp: Date(),
        from: UserKey.blankUser,
        to: UserKey.blankUser,
        title: "",
        content: "No Messages!"
    )
}
