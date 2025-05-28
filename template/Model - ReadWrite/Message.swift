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

protocol Message: Listable {
    var from: UserKey { get }
    var to: UserKey { get }
    var title: String { get }
    var content: String { get }
}

enum MessageStatusCode: String, Codable { case
    pending,
    sent,
    read,
    deleted,
    error
}

struct PublicComment: Message {
    private(set) var tournamentId: UUID?
    private(set) var id: UUID?
    private(set) var timestamp: Date?
    let from: UserKey
    let to: UserKey
    let title: String
    let content: String
    var references: Set<UUID> = []
    
    static let typeDescription = "Comment"
    var objectDescription: String { from.displayName + ": " + content }
    
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

struct PrivateMessage: Message  {
    private(set) var id: UUID?
    private(set) var timestamp: Date?
    var status: MessageStatusCode?
    let from: UserKey
    let to: UserKey
    let title: String
    let content: String
    var references: Set<UUID> = []
    
    static let typeDescription = "Message"
    var objectDescription: String { "Message from " + from.displayName + ": " + content }
    
    var isValid: Bool {
        guard status != .error,
              !title.isEmpty,
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

struct MessageReference {
    let id: UUID
    let referenceId: UUID
}

// used to send and persist a Message:
struct MessageCandidate {
    let from: UserKey
    var to: UserKey
    var title: String
    var content: String
    var references: Set<UUID> = []
    let typeDescription: String
}

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
