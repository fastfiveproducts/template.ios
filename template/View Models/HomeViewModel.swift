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
    var currentUserService: CurrentUserService
    
    init(currentUserService: CurrentUserService) {
        self.currentUserService = currentUserService
        super.init()
    }
            
    
    // ***** ViewModel Factories *****
    
    func makePublishCommentViewModel() -> SendMessageViewModel<PublicComment> {
        return SendMessageViewModel(
            captureCandidate: MessageCandidate(
                from: currentUserService.userKey,
                to: UserAccount.blankUser.userKey,
                title: "",
                content: ""),
//            translate: { [weak self] candidate in
//                return candidate
//            },
            action: { [weak self] message in        // <--- TODO ? Why is this a weak self?
                let commentId = try await MessagesConnector().createPublicComment(message)  // <--- TODO have a way to just print a message when in Previews
                let sentMessage = PublicComment(
                    id: commentId,
                    timestamp: Date(),
                    from: message.from,
                    to: message.to,
                    title: message.title,
                    content: message.content
                )
                print(sentMessage)     // <-- TODO need to add the sent message to the Message Store (or force a refresh)
            }
        )
    }

    func makeSendMessageViewModel() -> SendMessageViewModel<PrivateMessage> {
        return SendMessageViewModel(
            captureCandidate: MessageCandidate(
                from: currentUserService.userKey,
                to: currentUserService.userKey,        // <--- TODO we are just sending it to ourselves for now
                title: "",
                content: ""),
            //            translate: { [weak self] candidate in
            //                return candidate
            //            },
            action: { [weak self] message in    // <--- TODO ? Why is this a weak self?
                let messageId = try await MessagesConnector().createPrivateMessage(message) // <--- TODO have a way to just print a message when in Previews
                let sentMessage = PrivateMessage(
                    id: messageId,
                    timestamp: Date(),
                    from: message.from,
                    to: message.to,
                    title: message.title,
                    content: message.content)
                print(sentMessage)     // <-- TODO need to add the sent message to the Message Store (or force a refresh)
            }
        )
    }
}
