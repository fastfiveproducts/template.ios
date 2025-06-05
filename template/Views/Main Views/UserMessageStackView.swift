//
//  UserMessageStackView.swift
//
//  Created by Pete Maiser, January 2025 through May 2025
//      made availble here:
//      https://github.com/fastfiveproducts/template.ios
//      per terms of the MIT License
//      changes should be rare; it is recommended changes are applied to the template
//      and the entire file compared-and-then-replaced here if/as appropriate
//


import SwiftUI

struct UserMessageStackView: View, DebugPrintable {
    @ObservedObject var currentUserService: CurrentUserService
    @ObservedObject var viewModel: CreatePostViewModel<PrivateMessage>
    @ObservedObject var store: PrivateMessageStore

    var body: some View {
        VStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Write Message")
                    .font(.headline)

                Text("To User Placeholder") // TODO: Replace with user lookup

                LabeledContent {
                    TextField("new message", text: $viewModel.capturedTitleText)
                        .padding(4)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.secondary, lineWidth: 1)
                        )
                } label: {
                    Text("subject")
                }
                .labeledContentStyle(TopLabeledContentStyle())

                LabeledContent {
                    TextEditor(text: $viewModel.capturedContentText)
                        .frame(minHeight: 80)
                        .padding(4)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.secondary, lineWidth: 1)
                        )
                } label: {
                    Text("message text")
                }
                .labeledContentStyle(TopLabeledContentStyle())

                Button(action: submit) {
                    if viewModel.isWorking {
                        ProgressView()
                    } else {
                        Text("Send New Message")
                            .frame(maxWidth: .infinity)
                    }
                }
                .padding()
                .background(Color.accentColor)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
            .padding()
            .background(Color(.systemGroupedBackground))
            .cornerRadius(12)
            .onSubmit(submit)
            .onChange(of: viewModel.isWorking) {
                guard !viewModel.isWorking, viewModel.error == nil else { return }
            }

            VStack(alignment: .leading, spacing: 8) {
                Text("Inbox")       // TODO: touch here to open a browing-specific View
                    .font(.headline)
                    .padding(.horizontal)
                PostsScrollView(
                    store: store,
                    currentUserId: currentUserService.userKey.uid,
                    toUserId: currentUserService.userKey.uid,
                    showFromUser: true
                )
            }

            Divider()

            VStack(alignment: .leading, spacing: 8) {
                Text("Sent")        // TODO: touch here to open a browing-specific View
                    .font(.headline)
                    .padding(.horizontal)
                PostsScrollView(
                    store: store,
                    currentUserId: currentUserService.userKey.uid,
                    fromUserId: currentUserService.userKey.uid,
                    showToUser: true
                )
            }
        }
        .padding()
        .dynamicTypeSize(...ViewConfiguration.dynamicSizeMax)
        .environment(\.font, Font.body)
        .disabled(viewModel.isWorking)
        .alert("Error", error: $viewModel.error)
    }

    private func submit() {
        debugprint("(View) submit called")
        viewModel.isWorking = true
        Task {
            do {
                viewModel.postCandidate = PostCandidate(
                    from: currentUserService.userKey,
                    to: currentUserService.userKey,         // TODO: Replace with actual recipient
                    title: viewModel.capturedTitleText,
                    content: viewModel.capturedContentText
                )
                viewModel.createdPostId = try await PostsConnector().createPrivateMessage(viewModel.postCandidate)
                viewModel.createdPost = PrivateMessage(
                    id: viewModel.createdPostId,
                    timestamp: Date(),
                    from: viewModel.postCandidate.from,
                    to: viewModel.postCandidate.to,
                    title: viewModel.postCandidate.title,
                    content: viewModel.postCandidate.content
                )
                debugprint( viewModel.createdPost.objectDescription)
                viewModel.isWorking = false
            } catch {
                debugprint("Cloud Error sending Message: \(error).")
                viewModel.isWorking = false
                viewModel.error = error
            }
        }
    }
}


#if DEBUG
#Preview  {
    let currentUserService = CurrentUserTestService.sharedSignedIn
    let viewModel = CreatePostViewModel<PrivateMessage>()
    let store = PrivateMessageStore.testLoaded()
    UserMessageStackView(
        currentUserService: currentUserService,
        viewModel: viewModel,
        store: store
    )
}
#endif
