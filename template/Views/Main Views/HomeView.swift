//
//  HomeView.swift
//
//  Template by Pete Maiser, July 2024 through May 2025
//      made availble here:
//      https://github.com/fastfiveproducts/template.ios
//      provided via, and used per, terms of the MIT License
//
//  This particular implementation is for:
//      APP_NAME
//      DATE
//      YOUR_NAME
//


import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel: HomeViewModel
    @ObservedObject var currentUserService: CurrentUserService
    @ObservedObject var announcementStore: AnnouncementStore
    @ObservedObject var publicCommentStore: PublicCommentStore
    @ObservedObject var privateMessageStore: PrivateMessageStore
    
    var body: some View {
        NavigationStack {
            Form {
                // Live Announcements
                // also an example of StoreListSectionView, with data
                StoreListSectionView(store: announcementStore)
                
                // This is Placeholder-Test Content, and shows Nothing!
                StoreListSectionView(store: ListableStore<Announcement>.testEmpty())
                
                // This is Placeholder-Test Content, List View
                Section(header: Text("Test Announcements")) {
                    StoreListView(store: ListableStore<Announcement>.testLoaded(with: Announcement.testObjects))
                }

                // This is Placeholder-Test Content
                TextCaptureSectionView()
                
                // Live Comments, configured for User Testing Support
                Section(header: Text("Test Talk")) {
                    if currentUserService.isSignedIn {
                        NavigationLink(
                            "Write Comment",
                            destination: UserCommentStackView(
                                currentUserService: currentUserService,
                                viewModel: CreatePostViewModel<PublicComment>(),
                                store: publicCommentStore
                            )
                        )
                    }
                    PostsScrollView(
                        store: publicCommentStore,
                        currentUserId: currentUserService.userKey.uid,
                        showFromUser: true
                    )
                }
                
            }
            .padding()
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("Template")
                        .font(.title)
                }
                
                if currentUserService.isSignedIn {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink(
                            destination: UserMessageStackView(
                                currentUserService: currentUserService,
                                viewModel: CreatePostViewModel<PrivateMessage>(),
                                store: privateMessageStore,
                            ),
                            label: {
                                Label("Messages", systemImage: "envelope")
                            }
                        )
                        .buttonStyle(BorderlessButtonStyle())
                    }
                }
                                
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(
                        destination: UserAccountView(
                            viewModel: UserAccountViewModel(),
                            currentUserService: currentUserService
                        ),
                        label: {
                            currentUserService.isSignedIn ? Image(systemName: "person.fill"):Image(systemName: "person")
                        }
                    )
                    .buttonStyle(BorderlessButtonStyle())
                }
            }
            .dynamicTypeSize(...ViewConfiguration.dynamicSizeMax)
            .environment(\.font, Font.body)
        } // NavigationStack
    }
}


#if DEBUG
#Preview ("test-data signed-in") {
    let currentUserService = CurrentUserTestService.sharedSignedIn
    HomeView(
        viewModel: HomeViewModel(),
        currentUserService: currentUserService,
        announcementStore: AnnouncementStore.testLoaded(),
        publicCommentStore: PublicCommentStore.testLoaded(),
        privateMessageStore: PrivateMessageStore.testLoaded()
    )
}
#Preview ("test-data signed-out") {
    let currentUserService = CurrentUserTestService.sharedSignedOut
    HomeView(
        viewModel: HomeViewModel(),
        currentUserService: currentUserService,
        announcementStore: AnnouncementStore.testLoaded(),
        publicCommentStore: PublicCommentStore.testLoaded(),
        privateMessageStore: PrivateMessageStore.testLoaded()
    )
}
#endif
