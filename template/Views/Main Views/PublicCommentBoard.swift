//
//  PublicCommentBoard.swift
//
//  Created by Pete Maiser, January 2025 through May 2025
//      made availble here:
//      https://github.com/fastfiveproducts/template.ios
//      per terms of the MIT License
//      changes should be rare; it is recommended changes are applied to the template
//      and the entire file compared-and-then-replaced here if/as appropriate
//


import SwiftUI

struct PublicCommentBoard: View {
    @ObservedObject var store: PublicCommentStore
    var currentUserId: String
    @ObservedObject var sendViewModel: SendMessageViewModel<PublicComment>
         
    var body: some View {
        NavigationStack {
            Form {
                Section (header: Text("New Comment")){
                    TextEditorWithPlaceholder(
                        text: $sendViewModel.captureCandidate.content,
                        placeholder: "Comment Content"
                    )
                    Button(action: sendViewModel.submit) {
                        if sendViewModel.isWorking {
                            ProgressView()
                        } else {
                            Text("Submit New Comment")
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.white)
                    .listRowBackground(Color.accentColor)
                }

                Section(header: Text("Past Comments")) {
                    MessageListView(store: store, fromUserId: currentUserId, messagePerspective: .sent)
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
    let svm = hvm.makePublishCommentViewModel()
    PublicCommentBoard(
        store: PublicCommentStore.testLoaded(),
        currentUserId: currentUserService.userKey.uid,
        sendViewModel: svm
    )
}
#endif
