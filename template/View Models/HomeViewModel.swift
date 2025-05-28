//
//  HomeViewModel.swift
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

class HomeViewModel: SignInOutObserver {
    
    // ***** Setup *****
    var currentUser: CurrentUserService
    
    init(currentUser: CurrentUserService) {
        self.currentUser = currentUser
        super.init()
    }
    
    /*
    convenience init(currentUser: CurrentUser) {
        self.init(
            currentUser: currentUser,
            INSERT OTHERS AS NEEDED...
        )
    }
    */
       

    // ***** Announcements *****
    let announcementStore: AnnouncementStore = AnnouncementStore.shared
    
    func fetchAnnouncements() {
        // we will just get annoucements one time, for now
        if announcementStore.list == .empty {
            Task {
                try await announcementStore.fetchAnnouncements()
            }
        } else if case .error(_) = announcementStore.list {
            // perhaps the error was corrected
            Task {
                try await announcementStore.fetchAnnouncements()
            }
        }
    }
       
    
    // ***** ViewModel Factories *****
    
    func makePublishPublicCommentViewModel() -> SendMessageViewModel<PublicComment> {
        return SendMessageViewModel(
            captureCandidate: MessageCandidate(
                from: currentUser.userKey,
                to: User.blankUser.userKey,
                title: "",
                content: "",
                typeDescription: PublicComment.typeDescription),
            translate: { [weak self] candidate in
                return PublicComment(
                    from: candidate.from,
                    to: candidate.to,
                    title: candidate.title,
                    content: candidate.content)
            },
            action: { [weak self] message in
                let commentId = try await MessageService().createPublicComment(message)
                let sentMessage = PublicComment(
                    tournamentId: message.tournamentId,
                    id: commentId,
                    from: message.from,
                    to: message.to,
                    title: message.title,
                    content: message.content
                )
                var sentMessages = [sentMessage]
                if case let .loaded(pastMessages) = self?.commentBoard.list {
                    sentMessages += pastMessages
                }
                self?.commentBoard.list = .loaded(sentMessages)
            }
        )
    }

    func makeSendPrivateMessageViewModel() -> SendMessageViewModel<PrivateMessage> {
        return SendMessageViewModel(
            captureCandidate: MessageCandidate(
                from: currentUser.userKey,
                to: currentUser.userKey,        // TODO: we are just sending it to ourselves for now
                title: "",
                content: "",
                typeDescription: PrivateMessage.typeDescription),
            translate: { candidate in
                return PrivateMessage(
                    status: .sent,              // TODO: this needs to be more sophisticated
                    from: candidate.from,
                    to: candidate.to,
                    title: candidate.title,
                    content: candidate.content)
            },
            action: { [weak self] message in
                let messageId = try await MessageService().createPrivateMessage(message)
                let sentMessage = PrivateMessage(
                    id: messageId,
                    status: .sent,
                    from: message.from,
                    to: message.to,
                    title: message.title,
                    content: message.content)
                var sentMessages = [sentMessage]
                if case let .loaded(pastMessages) = self?.currentUser.messagesToUser {
                    sentMessages += pastMessages
                }
                self?.currentUser.messagesToUser = .loaded(sentMessages)
            }
        )
    }
    
    
    // ***** User-Session Cleanup *****
    override func postSignOutCleanup() {
        super.postSignOutCleanup()
    }
    
}

#if DEBUG
class HomeViewModelPreview: HomeViewModel {
    static let shared = HomeViewModel(currentUser: CurrentUserService.shared)
}

class HomeViewModelTestData: HomeViewModel {
    static let shared = HomeViewModelTestData()
    
    init() {
        super.init(
            currentUser: CurrentUserTestData.sharedSignedIn,
        )
        debugprint ("init called; isPreviewTestData: \(isPreviewTestData)")
    }
    
    override func makePublishPublicCommentViewModel() -> SendMessageViewModel<PublicComment> {
        return SendMessageViewModel(
            captureCandidate: MessageCandidate(
                from: PublicComment.testComment.from,
                to: User.blankUser.userKey,
                title: "",
                content: "",
                typeDescription: PublicComment.typeDescription),
            translate: { candidate in
                return PublicComment(
                    from: candidate.from,
                    to: candidate.to,
                    title: candidate.title,
                    content: candidate.content)
            },
            action: { [weak self] message in
                self?.debugprint("Fake send to Cloud: \(message)")
                // TODO: make the below a function so it is not copied from above to here?
                var sentMessages = [message]
                if case let .loaded(pastMessages) = self?.commentBoard.list {
                    sentMessages += pastMessages
                }
                self?.commentBoard.list = .loaded(sentMessages)
            }
        )
    }

    override func makeSendPrivateMessageViewModel() -> SendMessageViewModel<PrivateMessage> {
        return SendMessageViewModel(
            captureCandidate: MessageCandidate(
                from: PrivateMessage.testMessage.from,
                to: PrivateMessage.testMessage.to,
                title: "title",
                content: "message content...",
                typeDescription: PrivateMessage.typeDescription),
            translate: { candidate in
                return PrivateMessage(
                    from: candidate.from,
                    to: candidate.to,
                    title: candidate.title,
                    content: candidate.content)
            },
            action: { [weak self] message in
                self?.debugprint("Fake send of Private Message to Cloud: \(message)")
                // T make the below a function so it is not copied-changed from above to here?
                let sentMessage = PrivateMessage(id: UUID(), status: .sent, from: message.from, to: message.to, title: message.title, content: message.content)
                var sentMessages = [sentMessage]
                if case let .loaded(pastMessages) = self?.currentUser.messagesToUser {
                    sentMessages += pastMessages
                }
                self?.currentUser.messagesToUser = .loaded(sentMessages)
            }
        )
    }
}
#endif
