//
//  PostsScrollView.swift
//
//  Created by Pete Maiser, January 2025 through May 2025
//      made availble here:
//      https://github.com/fastfiveproducts/template.ios
//      per terms of the MIT License
//      changes should be rare; it is recommended changes are applied to the template
//      and the entire file compared-and-then-replaced here if/as appropriate
//


import SwiftUI

struct PostsScrollView<T: Post>: View {
    @ObservedObject var store: ListableStore<T>
    var currentUserId: String

    // Optional filters
    var fromUserId: String?
    var toUserId: String?
    
    // Optional visuals
    var showFromUser: Bool = false
    var showToUser: Bool = false
    var hideWhenEmpty: Bool = false

    // Apply filters
    private var filteredPosts: [T] {
        guard case let .loaded(posts) = store.list else { return [] }
        return posts.filter { post in
            let toMatch = toUserId == nil || post.to.uid == toUserId
            let fromMatch = fromUserId == nil || post.from.uid == fromUserId
            return toMatch && fromMatch
        }
    }

    var body: some View {
        switch store.list {
        case .loading:
            ProgressView("Loading...")
                .frame(maxWidth: .infinity, alignment: .center)
                .padding()

        case .error(let error):
            Text("Error loading content: \(error.localizedDescription)")
                .foregroundColor(.red)
                .padding()

        case .none:
            Text("nothing here")
                .padding(.top, 10)

        case .loaded:
            if filteredPosts.isEmpty {
                if hideWhenEmpty {
                    EmptyView()
                } else {
                    Text("None!")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        .padding(.top, 10)
                }
            } else {
                ScrollView {
                    LazyVStack(spacing: 4) {
                        ForEach(filteredPosts) { post in
                            PostBubbleView(
                                post: post,
                                isSent: post.from.uid == currentUserId,
                                showFromUser: showFromUser,
                                showToUser: showToUser
                            )
                        }
                    }
                    .padding(.top, 10)
                }
            }
        }
    }
}


#if DEBUG
#Preview {
    let currentUserService = CurrentUserTestService.sharedSignedIn

    ScrollView {
        VStack(alignment: .leading, spacing: 24) {
            Section(header: Text("My Published Comments")) {
                PostsScrollView(
                    store: PublicCommentStore.testLoaded(),
                    currentUserId: currentUserService.userKey.uid,
                    fromUserId: currentUserService.userKey.uid,
                )
            }
            
            Section(header: Text("All Comments")) {
                PostsScrollView(
                    store: PublicCommentStore.testLoaded(),
                    currentUserId: currentUserService.userKey.uid,
                    showFromUser: true
                )
            }
        

            Section(header: Text("Inbox Messages")) {
                PostsScrollView(
                    store: PrivateMessageStore.testLoaded(),
                    currentUserId: currentUserService.userKey.uid,
                    toUserId: currentUserService.userKey.uid,
                    showFromUser: true
                )
            }
            
            Section(header: Text("Inbox Empty")) {
                PostsScrollView(
                    store: PrivateMessageStore.testEmpty(),
                    currentUserId: currentUserService.userKey.uid,
                    toUserId: currentUserService.userKey.uid,
                    showFromUser: true
                )
            }

            Section(header: Text("Sent Messages")) {
                PostsScrollView(
                    store: PrivateMessageStore.testLoaded(),
                    currentUserId: currentUserService.userKey.uid,
                    fromUserId: currentUserService.userKey.uid,
                    showToUser: true
                )
            }

            Section(header: Text("All Messages")) {
                PostsScrollView(
                    store: PrivateMessageStore.testLoaded(),
                    currentUserId: currentUserService.userKey.uid,
                    showFromUser: true,
                    showToUser: true
                )
            }
        }
        .padding()
    }
    .dynamicTypeSize(...ViewConfiguration.dynamicSizeMax)
    .environment(\.font, Font.body)
}
#endif
