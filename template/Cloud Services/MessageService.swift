//
//  MessageService.swift
//
//  Created by Pete Maiser, January 2025 through May 2025
//      made availble here:
//      https://github.com/fastfiveproducts/template.ios
//      per terms of the MIT License
//      changes should be rare; it is recommended changes are applied to the template
//      and the entire file compared-and-then-replaced here if/as appropriate
//


import Foundation
import FirebaseDataConnect
import DefaultConnector

struct MessageService {
    
    func fetchPublicComments(limit:Int? = nil) async throws -> [PublicComment] {
        var comments: [PublicComment] = []
        if limit != nil {
            let queryRef = DataConnect.defaultConnector.listPublicCommentsQuery.ref(limit: limit!)
            let operationResult = try await queryRef.execute()
            let comments = try operationResult.data.publicComments.compactMap { firebaseComment -> Message? in
                let comment = try makeComment(from: firebaseComment)
                guard comment.isValid else { throw FetchDataError.invalidCloudData }
                return comment
            }
            return comments
        }
    }
    
    func fetchPublicCommentReferences(for commentId:UUID) async throws -> [MessageReference] {
        let queryRef = DataConnect.defaultConnector.getPublicCommentReferencesQuery.ref(commentId: commentId)
        let operationResult = try await queryRef.execute()
        let references = try operationResult.data.publicCommentReferences.compactMap { firebaseReference -> MessageReference? in
            return try makeMessageReference(from: firebaseReference)
        }
        return references
    }
    
    func fetchPublicCommentReferences(limit:Int? = nil) async throws -> [MessageReference] {
        var references: [MessageReference] = []
        if limit != nil {
            let queryRef = DataConnect.defaultConnector.getLatestPublicCommentReferencesQuery.ref(limit: limit!)
            let operationResult = try await queryRef.execute()
            references = try operationResult.data.publicCommentReferences.compactMap { firebaseReference -> MessageReference? in
                return try makeMessageReference(from: firebaseReference)
            }
        } else {
            let queryRef = DataConnect.defaultConnector.getAllPublicCommentReferencesQuery.ref()
            let operationResult = try await queryRef.execute()
            references = try operationResult.data.publicCommentReferences.compactMap { firebaseReference -> MessageReference? in
                return try makeMessageReference(from: firebaseReference)
            }
        }
        return references
    }
            
    func fetchPrivateMessagesToUser(uid: String) async throws -> [PrivateMessage] {
        guard !uid.isEmpty else { throw FetchDataError.invalidFunctionInput }
        let queryRef = DataConnect.defaultConnector.getPrivateMessagesToUserQuery.ref(uid: uid)
        let operationResult = try await queryRef.execute()
        let messages = try operationResult.data.privateMessages.compactMap { firebaseMessage -> PrivateMessage? in
            let message = try makePrivateMessage(from: firebaseMessage)
            guard message.isValid else { throw FetchDataError.invalidCloudData }
            return message
        }
        return messages
    }
    
    func fetchPrivateMessagesFromUser(uid: String) async throws -> [PrivateMessage] {
        guard !uid.isEmpty else { throw FetchDataError.invalidFunctionInput }
        let queryRef = DataConnect.defaultConnector.getPrivateMessagesFromUserQuery.ref(uid: uid)
        let operationResult = try await queryRef.execute()
        let messages = try operationResult.data.privateMessages.compactMap { firebaseMessage -> PrivateMessage? in
            let message = try makePrivateMessage(from: firebaseMessage)
            guard message.isValid else { throw FetchDataError.invalidCloudData }
            return message
        }
        return messages
    }
    
    func fetchPrivateMessageReferences(for messageId:UUID) async throws -> [MessageReference] {
        let queryRef = DataConnect.defaultConnector.getPrivateMessageReferencesQuery.ref(messageId: messageId)
        let operationResult = try await queryRef.execute()
        let references = try operationResult.data.privateMessageReferences.compactMap { firebaseReference -> MessageReference? in
            let reference = try makeMessageReference(from: firebaseReference)
            return reference
        }
        return references
    }
        
    func createPublicComment(_ comment: PublicComment) async throws -> UUID {
        guard comment.isValid else { throw UpsertDataError.invalidFunctionInput }
        let operationResult = try await DataConnect.defaultConnector.createPublicCommentMutation.execute(
            status: comment.status?.rawValue ?? MessageStatusCode.error.rawValue,
            title: comment.title,
            content: comment.content
        )
        let commentId = operationResult.data.publicComment_insert.id
        if !comment.references.isEmpty {
            for rid in comment.references {
                _ = try await DataConnect.defaultConnector.createPublicCommentReferenceMutation.execute(
                    commentId: commentId,
                    referenceId: rid
                )
            }
        }
        return commentId
    }
        
              
    func createPublicCommentReference(commentId: UUID, referenceId: UUID) async throws {
        _ = try await DataConnect.defaultConnector.createPublicCommentReferenceMutation.execute(
                    publicCommentId: commentId,
                    referenceId: referenceId
                )
        
    }
    
    func createPrivateMessage(_ message: PrivateMessage) async throws -> UUID {
        guard message.isValid else { throw UpsertDataError.invalidFunctionInput }
        let operationResult = try await DataConnect.defaultConnector.createPrivateMessageMutation.execute(
            status: message.status?.rawValue ?? MessageStatusCode.error.rawValue,
            fromUserId: message.from.uid,
            fromUserDisplayName: message.from.displayName,
            toUserId: message.to.uid,
            toUserDisplayName:message.to.displayName,
            title: message.title,
            content: message.content
        )
        let messageId = operationResult.data.privateMessage_insert.id
        if !message.references.isEmpty {
            for rid in message.references {
                _ = try await DataConnect.defaultConnector.createPrivateMessageReferenceMutation.execute(
                    privateMessageId: messageId,
                    referenceId: rid
                )
            }
        }
        return messageId
    }
    
    func updatePrivateMessageStatus(_ messageId: UUID, status: MessageStatusCode) async throws {
        _ = try await DataConnect.defaultConnector.updatePrivateMessageMutation.execute(
            id: messageId,
            status: status.rawValue
        )
    }
    
}


private extension MessageService {
    
    func makeMessageReference<T>(
        from firebaseReference: T
    ) throws -> MessageReference {
        let id: UUID
        let referenceId: UUID
        if let publicComment = firebaseReference as? GetPublicCommentReferencesQuery.Data.PublicCommentReference {
            id = publicComment.publicCommentId
            referenceId = publicComment.referenceId
        }
        else if let publicComment = firebaseReference as? GetLatestPublicCommentReferencesQuery.Data.PublicCommentReference {
            id = publicComment.publicCommentId
            referenceId = publicComment.referenceId
        }
        else if let publicComment = firebaseReference as? GetAllPublicCommentReferencesQuery.Data.PublicCommentReference {
            id = publicComment.publicCommentId
            referenceId = publicComment.referenceId
        } else if let privateMessage = firebaseReference as? GetPrivateMessageReferencesQuery.Data.PrivateMessageReference {
            id = privateMessage.privateMessageId
            referenceId = privateMessage.referenceId
        } else {
            throw FetchDataError.invalidFunctionInput
        }
        return MessageReference(
            id: id,
            referenceId: referenceId)
    }
    
    func makePrivateMessage(
        from firebaseMessage: GetPrivateMessagesFromUserQuery.Data.PrivateMessage
    ) throws -> PrivateMessage {
        return PrivateMessage(
            id: firebaseMessage.id,
            timestamp: firebaseMessage.timestamp.dateValue(),
            from: UserKey.init(uid: firebaseMessage.fromUserId, displayName: firebaseMessage.fromUserDisplayName),
            to: UserKey.init(uid: firebaseMessage.toUserId, displayName: firebaseMessage.toUserDisplayName),
            title: firebaseMessage.title,
            content: firebaseMessage.content,
            references: []
        )
        
    }
    
    func makePrivateMessage(
        from firebaseMessage: GetPrivateMessagesToUserQuery.Data.PrivateMessage
    ) throws -> PrivateMessage {
        return PrivateMessage(
            id: firebaseMessage.id,
            timestamp: firebaseMessage.timestamp.dateValue(),
            from: UserKey.init(uid: firebaseMessage.fromUserId, displayName: firebaseMessage.fromUserDisplayName),
            to: UserKey.init(uid: firebaseMessage.toUserId, displayName: firebaseMessage.toUserDisplayName),
            title: firebaseMessage.title,
            content: firebaseMessage.content,
            references: []
        )
        
    }

}
