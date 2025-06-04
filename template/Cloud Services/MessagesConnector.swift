//
//  MessagesConnector.swift
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

// Connector Defaults:
fileprivate let defaultFetchLimit: Int = 100

// Services:
struct MessagesConnector {
    
    func fetchPublicComments(limit:Int? = defaultFetchLimit) async throws -> [PublicComment] {
        var comments: [PublicComment] = []
        let queryRef = DataConnect.defaultConnector.listPublicCommentsQuery.ref(limit: limit!)
        let operationResult = try await queryRef.execute()
        comments = try operationResult.data.publicComments.compactMap { firebaseComment -> PublicComment? in
            let comment = try makePublicCommentStruct(from: firebaseComment)
            guard comment.isValid else { throw FetchDataError.invalidCloudData }
            return comment
        }
        return comments
    }
    
    func fetchMyPrivateMessages(limit:Int? = defaultFetchLimit) async throws -> [PrivateMessage] {
        var messages: [PrivateMessage] = []
        let queryRef = DataConnect.defaultConnector.getMyPrivateMessagesQuery.ref(limit: limit!)
        let operationResult = try await queryRef.execute()
        messages = try operationResult.data.privateMessages.compactMap { firebaseMessage -> PrivateMessage? in
            let message = try makePrivateMessageStruct(from: firebaseMessage)
            guard message.isValid else { throw FetchDataError.invalidCloudData }
            return message
        }
        return messages
    }
    
    func fetchPublicCommentReferences(for commentId:UUID, limit:Int? = defaultFetchLimit) async throws -> [MessageReference] {
        var references: [MessageReference] = []
        let queryRef = DataConnect.defaultConnector.getPublicCommentReferencesQuery.ref(commentId: commentId, limit: limit!)
        let operationResult = try await queryRef.execute()
        references = try operationResult.data.publicCommentReferences.compactMap { firebaseReference -> MessageReference? in
            let reference = try makeMessageReferenceStruct(from: firebaseReference)
            guard reference.isValid else { throw FetchDataError.invalidCloudData }
            return reference
        }
        return references
    }
        
    func fetchMyPrivateMessageReferences(limit:Int? = defaultFetchLimit) async throws -> [MessageReference] {
        var references: [MessageReference] = []
        let queryRef = DataConnect.defaultConnector.getMyPrivateMessageReferencesQuery.ref(limit: limit!)
        let operationResult = try await queryRef.execute()
        references = try operationResult.data.privateMessageReferences.compactMap { firebaseReference -> MessageReference? in
            let reference = try makeMessageReferenceStruct(from: firebaseReference)
            guard reference.isValid else { throw FetchDataError.invalidCloudData }
            return reference
        }
        return references
    }

    func fetchPrivateMessageReferences(for messageId:UUID, limit:Int? = defaultFetchLimit) async throws -> [MessageReference] {
        var references: [MessageReference] = []
        let queryRef = DataConnect.defaultConnector.getPrivateMessageReferencesQuery.ref(messageId: messageId, limit: limit!)
        let operationResult = try await queryRef.execute()
        references = try operationResult.data.privateMessageReferences.compactMap { firebaseReference -> MessageReference? in
            let reference = try makeMessageReferenceStruct(from: firebaseReference)
            guard reference.isValid else { throw FetchDataError.invalidCloudData }
            return reference
        }
        return references
    }
    
    func createPublicComment(_ comment: MessageCandidate) async throws -> UUID {
        guard comment.isValid else { throw UpsertDataError.invalidFunctionInput }
        let operationResult = try await DataConnect.defaultConnector.createPublicCommentMutation.execute(
            toUserId: comment.to.uid,
            createDeviceIdentifierstamp: deviceIdentifierstamp(),
            createDeviceTimestamp: deviceTimestamp(),
            title: comment.title,
            content: comment.content
        )
        let commentId = operationResult.data.publicComment_insert.id
        if !comment.references.isEmpty {
            for rid in comment.references {
                _ = try await createPublicCommentReference(commentId: commentId, referenceId: rid)
            }
        }
        return commentId
    }
    
    func createPrivateMessage(_ message: MessageCandidate) async throws -> UUID {
        guard message.isValid else { throw UpsertDataError.invalidFunctionInput }
        let operationResult = try await DataConnect.defaultConnector.createPrivateMessageMutation.execute(
            toUserId: message.to.uid,
            createDeviceIdentifierstamp: deviceIdentifierstamp(),
            createDeviceTimestamp: deviceTimestamp(),
            title: message.title,
            content: message.content
        )
        let messageId = operationResult.data.privateMessage_insert.id
        if !message.references.isEmpty {
            for rid in message.references {
                _ = try await createPrivateMessageReference(messageId: messageId, referenceId: rid)
            }
        }
        return messageId
    }
                         
    func createPublicCommentReference(commentId: UUID, referenceId: UUID) async throws {
        _ = try await DataConnect.defaultConnector.createPublicCommentReferenceMutation.execute(
                    publicCommentId: commentId,
                    referenceId: referenceId
                )
        
    }
    
    func createPrivateMessageReference(messageId: UUID, referenceId: UUID) async throws {
        _ = try await DataConnect.defaultConnector.createPrivateMessageReferenceMutation.execute(
            privateMessageId: messageId,
            referenceId: referenceId
        )
    }
    
    func createPrivateMessageStatus(messageId: UUID, status: MessageStatusCode) async throws {
        _ = try await DataConnect.defaultConnector.createPrivateMessageStatusMutation.execute(
            privateMessageId: messageId,
            status: status.rawValue
        )
    }
    
}

// helpers to make local structs:
private extension MessagesConnector {
           
    func makePublicCommentStruct(
        from firebaseMessage: ListPublicCommentsQuery.Data.PublicComment
    ) throws -> PublicComment {
        let toUserKey: UserKey = UserKey.blankUser  // TODO fix bug in client-server template:  no way to refer to linked 'to' user
        return PublicComment(
            id: firebaseMessage.id,
            timestamp: firebaseMessage.createTimestamp.dateValue(),
            from: UserKey.init(uid: firebaseMessage.createUser.id, displayName: firebaseMessage.createUser.displayNameText),
            to: toUserKey,
            title: firebaseMessage.title,
            content: firebaseMessage.content,
            references: []
        )
        
    }
    
    func makePrivateMessageStruct(
        from firebaseMessage: GetMyPrivateMessagesQuery.Data.PrivateMessage
    ) throws -> PrivateMessage {
        let toUserKey: UserKey = UserKey.blankUser  // TODO fix bug in client-server template:  no way to refer to linked 'to' user
        return PrivateMessage(
            id: firebaseMessage.id,
            timestamp: firebaseMessage.createTimestamp.dateValue(),
            from: UserKey.init(uid: firebaseMessage.createUser.id, displayName: firebaseMessage.createUser.displayNameText),
            to: toUserKey,
            title: firebaseMessage.title,
            content: firebaseMessage.content,
            references: [],
            status: []
        )
        
    }
    
    func makeMessageReferenceStruct<T>(
        from firebaseReference: T
    ) throws -> MessageReference {
        let id: UUID
        let referenceId: UUID
        if let publicComment = firebaseReference as? GetPublicCommentReferencesQuery.Data.PublicCommentReference {
            id = publicComment.publicCommentId
            referenceId = publicComment.referenceId
        } else if let privateMessage = firebaseReference as? GetMyPrivateMessageReferencesQuery.Data.PrivateMessageReference {
            id = privateMessage.privateMessageId
            referenceId = privateMessage.referenceId
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
    
    func makeMessageStatusStruct(
        from firebaseMessageStatus: GetMyPrivateMessageStatusQuery.Data.PrivateMessageStatus
    ) throws -> MessageStatus {
        var status: MessageStatusCode
        if let statusTry = MessageStatusCode(rawValue: firebaseMessageStatus.status) {
            status = statusTry
        } else { status = .error }
        return MessageStatus(
            timestamp: firebaseMessageStatus.createTimestamp.dateValue(),
            uid: firebaseMessageStatus.createUserId,
            status: status
        )
    }

}
