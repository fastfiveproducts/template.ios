//
//  UserCommentStackView.swift
//
//  Created by Pete Maiser, January 2025 through May 2025
//      made availble here:
//      https://github.com/fastfiveproducts/template.ios
//      per terms of the MIT License
//      changes should be rare; it is recommended changes are applied to the template
//      and the entire file compared-and-then-replaced here if/as appropriate
//


import SwiftUI

struct UserCommentStackView: View, DebugPrintable {
    @ObservedObject var currentUserService: CurrentUserService
    @ObservedObject var viewModel: CreatePostViewModel<PublicComment>
    @ObservedObject var store: PublicCommentStore
         
    var body: some View {
        VStack(spacing: 16) {
            
            // MARK: -- Write
            VStackBox(title: "Write Comment"){
                LabeledContent {
                    TextEditor(text: $viewModel.capturedContentText)
                        .frame(minHeight: 80, maxHeight: 100)
                        .padding(4)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.secondary, lineWidth: 1)
                        )
                } label: {
                    Text("Comment Text")
                }
                .labeledContentStyle(TopLabeledContentStyle())

                Button(action: submit) {
                    if viewModel.isWorking {
                        ProgressView()
                    } else {
                        Text("Submit New Comment")
                            .frame(maxWidth: .infinity)
                    }
                }
                .padding()
                .background(Color.accentColor)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
            .onSubmit(submit)
            .onChange(of: viewModel.isWorking) {
                guard !viewModel.isWorking, viewModel.error == nil else { return }
            }

            // MARK: -- Past Comments
            Divider()
            VStack(alignment: .leading, spacing: 8) {
                Text("Your Past Comments")      // TODO: touch here to open a browing-specific View
                    .font(.title3)
                    .fontWeight(.semibold)
                    .padding(.horizontal)

                PostsScrollView(
                    store: store,
                    currentUserId: currentUserService.userKey.uid,
                    fromUserId: currentUserService.userKey.uid
                )
                .padding(.horizontal)
            }
        }
        .dynamicTypeSize(...ViewConfiguration.dynamicSizeMax)
        .environment(\.font, Font.body)
        .disabled(viewModel.isWorking)
        .alert("Error", error: $viewModel.error)
    }
}


private extension UserCommentStackView {
    private func submit() {
        debugprint("(View) submit called")
        viewModel.isWorking = true
        Task {
            do {
                viewModel.postCandidate = PostCandidate(
                    from: currentUserService.userKey,
                    to: UserKey.blankUser,
                    title: viewModel.capturedTitleText,
                    content: viewModel.capturedContentText)
                viewModel.createdPostId = try await PostsConnector().createPublicComment(viewModel.postCandidate)   // <--- TODO have a way to just print when in Previews
                viewModel.createdPost = PublicComment(
                    id: viewModel.createdPostId,
                    timestamp: Date(),
                    from: viewModel.postCandidate.from,
                    to: viewModel.postCandidate.to,
                    title: viewModel.postCandidate.title,
                    content: viewModel.postCandidate.content
                )
                debugprint(viewModel.createdPost.objectDescription)       // <-- TODO need to add to the Store (or force a refresh)
                viewModel.isWorking = false
                return
            } catch {
                debugprint("Cloud Error publishing Comment: \(error).")
                viewModel.isWorking = false
                viewModel.error = error
                throw error
            }
        }
    }
}


#if DEBUG
#Preview  {
    let currentUserService = CurrentUserTestService.sharedSignedIn
    let viewModel = CreatePostViewModel<PublicComment>()
    let store = PublicCommentStore.testLoaded()
    UserCommentStackView(
        currentUserService: currentUserService,
        viewModel: viewModel,
        store: store
    )
}
#endif
