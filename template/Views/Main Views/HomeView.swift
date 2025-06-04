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
                StoreListSectionView(store: announcementStore)
                
                Section(header: Text("Home")) {
                    HStack {
                        Spacer()
                        VStack {
                            Image(systemName: "globe")
                                .imageScale(.large)
                                .foregroundStyle(.tint)
                            Text("Hello, world!")
                        }
                        Spacer()
                    }
                }
                
                Section(header: Text("Test Talk")) {
                    if currentUserService.isSignedIn {
                        NavigationLink(
                            "Write Comment",
                            destination: PublicCommentBoard(
                                store: publicCommentStore,
                                currentUserId: currentUserService.userAccount.userKey.uid,
                                sendViewModel: viewModel.makePublishCommentViewModel())
                        )
                    }
                    MessageListView(store: publicCommentStore, messagePerspective: .comment)
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
                            destination: PrivateMessageBoard(
                                store: privateMessageStore,
                                currentUserId: currentUserService.userAccount.userKey.uid,
                                sendViewModel: viewModel.makeSendMessageViewModel()
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
        viewModel: HomeViewModel(currentUserService: currentUserService),
        currentUserService: currentUserService,
        announcementStore: AnnouncementStore.testLoaded(),
        publicCommentStore: PublicCommentStore.testLoaded(),
        privateMessageStore: PrivateMessageStore.testLoaded()
    )
}
#Preview ("test-data signed-out") {
    let currentUserService = CurrentUserTestService.sharedSignedOut
    HomeView(
        viewModel: HomeViewModel(currentUserService: currentUserService),
        currentUserService: currentUserService,
        announcementStore: AnnouncementStore.testLoaded(),
        publicCommentStore: PublicCommentStore.testLoaded(),
        privateMessageStore: PrivateMessageStore.testLoaded()
    )
}
#endif
