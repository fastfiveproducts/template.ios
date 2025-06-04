//
//  PrivateMessageBoard.swift
//
//  Created by Pete Maiser, January 2025 through May 2025
//      made availble here:
//      https://github.com/fastfiveproducts/template.ios
//      per terms of the MIT License
//      changes should be rare; it is recommended changes are applied to the template
//      and the entire file compared-and-then-replaced here if/as appropriate
//


import SwiftUI

struct PrivateMessageBoard: View {
    @ObservedObject var store: PrivateMessageStore
    var currentUserId: String
    @ObservedObject var sendViewModel: SendMessageViewModel<PrivateMessage>
         
    var body: some View {
        NavigationStack {
            Form {
                Section (header: Text("Write Message")){
                    TextField("To User ID", text: $sendViewModel.captureCandidate.title)    // TODO replace with a User Lookup
                    TextField("Subject", text: $sendViewModel.captureCandidate.title)
                    TextEditorWithPlaceholder(
                        text: $sendViewModel.captureCandidate.content,
                        placeholder: "Message Content"
                    )
                    Button(action: sendViewModel.submit) {
                        if sendViewModel.isWorking {
                            ProgressView()
                        } else {
                            Text("Send New Message")
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.white)
                    .listRowBackground(Color.accentColor)
                }


                Section(header: Text("Inbox Messages")) {
                    MessageListView(store: store, toUserId: currentUserId)
                }

                Section(header: Text("Sent Messages")) {
                    MessageListView(store: store, fromUserId: currentUserId)
                }
            }
            .onSubmit(sendViewModel.submit)
            .onChange(of: sendViewModel.isWorking) {
                guard !sendViewModel.isWorking, sendViewModel.error == nil else { return }
            }
            .dynamicTypeSize(...ViewConfiguration.dynamicSizeMax)
            .environment(\.font, Font.body)
        }// NavigationStack
        .disabled(sendViewModel.isWorking)
        .alert("Error", error: $sendViewModel.error)
        .padding()
    }
}


#if DEBUG
#Preview  {
    let currentUserService = CurrentUserTestService.sharedSignedIn
    let hvm = HomeViewModel(currentUserService: currentUserService)
    let svm = hvm.makeSendMessageViewModel()
    PrivateMessageBoard(
        store: PrivateMessageStore.testLoaded(),
        currentUserId: currentUserService.userKey.uid,
        sendViewModel: svm
    )
}
#endif
