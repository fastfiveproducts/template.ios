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
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {

                    // MARK: -- Announcements
                    VStackBox(title: "Announcements") {
                        StoreListView(store: announcementStore)
                            .padding(.horizontal)

                        if !currentUserService.isSignedIn {
                            Divider().padding(.horizontal)
                            NavigationLink(destination: UserAccountView(
                                viewModel: UserAccountViewModel(),
                                currentUserService: currentUserService
                            )) {
                                HStack {
                                    Text("Tap Here or ") + Text(Image(systemName: "person")) + Text(" to Sign In!")
                                }
                                .foregroundColor(.accentColor)
                                .padding(.horizontal)
                            }
                        }
                    }
                    
                    // MARK: -- Text Capture Section
                    VStackBox(title: "Text Capture Sample") {
                        TextCaptureSectionView(showHeader: false)
                            .padding(.horizontal)
                            .background(Color(.systemGroupedBackground))
                            .cornerRadius(6)
                            .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)

                    }

                    // MARK: -- Testing Talk
                    Divider().padding(.horizontal)
                    VStackBox {
                        HStack {
                            Text("Testing Talk")
                                .font(.title2)
                                .fontWeight(.semibold)
                            Spacer()
                            if currentUserService.isSignedIn {
                                NavigationLink {
                                    UserCommentStackView(
                                        currentUserService: currentUserService,
                                        viewModel: CreatePostViewModel<PublicComment>(),
                                        store: publicCommentStore
                                    )
                                } label: {
                                    Text("Write a Comment")
                                        .font(.caption)
                                        .foregroundColor(.accentColor)
                                }
                            }
                        }
                    } content: {
                        if currentUserService.isSignedIn {
                            PostsScrollView(
                                store: publicCommentStore,
                                currentUserId: currentUserService.userKey.uid,
                                showFromUser: true,
                                hideWhenEmpty: true
                            )
                        } else {
                            HStack {
                                Text("Not Signed In!")
                                Spacer()
                                Text("...tap ") + Text(Image(systemName: "person")) + Text(" above")
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                .padding(.vertical)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("Template")
                        .font(.title)
                }
                
                // MARK: -- Messages
                if currentUserService.isSignedIn
                && privateMessageStore.list.count > 0       //  only displays when messages exist, essentially turning-off Message functionality
                {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink(destination: UserMessageStackView(
                            currentUserService: currentUserService,
                            viewModel: CreatePostViewModel<PrivateMessage>(),
                            store: privateMessageStore
                        )) {
                            Label("Messages", systemImage: "envelope")
                        }
                        .buttonStyle(BorderlessButtonStyle())
                    }
                }
                
                // MARK: -- User Account & Profile
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: UserAccountView(
                        viewModel: UserAccountViewModel(),
                        currentUserService: currentUserService
                    )) {
                        Image(systemName: currentUserService.isSignedIn ? "person.fill" : "person")
                    }
                    .buttonStyle(BorderlessButtonStyle())
                }
            }
            .dynamicTypeSize(...ViewConfiguration.dynamicSizeMax)
            .environment(\.font, Font.body)
        }
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
<<<<<<< HEAD
        privateMessageStore: PrivateMessageStore.testLoaded()
=======
        privateMessageStore: PrivateMessageStore()              // loading empty because private messages not used yet
>>>>>>> develop
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
#Preview ("Sample Form View") {
    SampleFormView()
}

struct SampleFormView: View {
    var body: some View {
        Form {

            // This is a Placeholder-Test StoreListView, with test data
            Section(header: Text("Announcements")) {
                StoreListView(store: ListableStore<Announcement>.testLoaded(with: Announcement.testObjects), showDividers: false)
            }
            
            // This is a Placeholder-Test Text Capture View
            TextCaptureSectionView()
            
            // This is a Placeholder-Test StoreListSectionView, with test data
            StoreListSectionView(store: ListableStore<Announcement>.testLoaded(with: Announcement.testObjects))
            
            // This is a Placeholder-Test StoreListSectionView disappearing when there is no data!
            StoreListSectionView(store: ListableStore<Announcement>.testEmpty())
            
        }
        .dynamicTypeSize(...ViewConfiguration.dynamicSizeMax)
        .environment(\.font, Font.body)
    }
}
#endif
