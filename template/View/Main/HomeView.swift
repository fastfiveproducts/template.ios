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
                        ListableStoreView(store: announcementStore)
                            .padding(.horizontal)

                        if !currentUserService.isSignedIn {
                            Divider().padding(.horizontal)
                            NavigationLink {
                                UserAccountView(
                                    viewModel: UserAccountViewModel(),
                                    currentUserService: currentUserService)
                            } label: {
                                HStack {
                                    Text("Tap Here or ") + Text(Image(systemName: "person")) + Text(" to Sign In!")
                                }
                                .foregroundColor(.accentColor)
                                .padding(.horizontal)
                            }
                        }
                    }
                    
                    // MARK: -- Text Capture Section, Local File
                    Divider().padding(.horizontal)
                    VStackBox {
                        HStack {
                            Text ("Local File Sample")
                                .font(.title2)
                                .fontWeight(.semibold)
                            Spacer()
                            NavigationLink {
                                VStackBox() {
                                    Text("Replace this VStackBox with a Detail View!")
                                }
                            } label: {
                                Text("Records")
                                    .font(.caption)
                                    .foregroundColor(.accentColor)
                            }
                        }
                    } content: {
                        FormCaptureView(
                            viewModel: FormCaptureViewModel<StructSample>.configured(),
                            showHeader: false,
                            onSubmit: { result in
                                print("Captured StructSample: \(result)")
                            }
                        )
                            .padding(.horizontal)
                            .background(Color(.systemGroupedBackground))
                            .cornerRadius(6)
                            .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
                    }
                    
                    // MARK: -- Text Capture Section, SwiftData
                    Divider().padding(.horizontal)
                    VStackBox {
                        HStack {
                            Text ("SwiftData Sample")
                                .font(.title2)
                                .fontWeight(.semibold)
                            Spacer()
                            if currentUserService.isSignedIn {
                                NavigationLink {
                                    VStackBox() {
                                        Text("Replace this VStackBox with a Detail View!")
                                    }
                                } label: {
                                    Text("Records")
                                        .font(.caption)
                                        .foregroundColor(.accentColor)
                                }
                            }
                        }
                    } content: {
                        if currentUserService.isSignedIn {
                            FormCaptureView(
                                viewModel: FormCaptureViewModel<StructSample>.configured(),
                                showHeader: false,
                                onSubmit: { result in
                                    print("Captured StructSample: \(result)")
                                }
                            )
                                .padding(.horizontal)
                                .background(Color(.systemGroupedBackground))
                                .cornerRadius(6)
                                .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
                        }  else {
                            HStack {
                                Text("Not Signed In!")
                                Spacer()
                                Text("...tap ") + Text(Image(systemName: "person")) + Text(" above")
                            }
                            .padding(.horizontal)
                        }
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
                
                // MARK: -- Activity Log
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        VStackBox() {
                            Text("Replace this VStackBox with an Activity Log View!")
                        }
                    } label: {
                        Label("Activity Log", systemImage: "book.pages")
                    }
                    .buttonStyle(BorderlessButtonStyle())
                }
                
                
                // MARK: -- Settings
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        VStackBox() {
                            Text("Replace this VStackBox with a Settings View!")
                        }
                    } label: {
                        Label("Settings", systemImage: "gearshape.fill")
                    }
                    .buttonStyle(BorderlessButtonStyle())
                }
                
                // MARK: -- Messages
                if currentUserService.isSignedIn
                && privateMessageStore.list.count > 0       //  only displays when messages exist, essentially turning-off Message functionality
                {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink {
                            UserMessageStackView(
                                currentUserService: currentUserService,
                                viewModel: CreatePostViewModel<PrivateMessage>(),
                                store: privateMessageStore)
                        } label: {
                            Label("Messages", systemImage: "envelope")
                        }
                        .buttonStyle(BorderlessButtonStyle())
                    }
                }
                
                // MARK: -- User Account & Profile
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        UserAccountView(
                            viewModel: UserAccountViewModel(),
                            currentUserService: currentUserService)
                    } label: {
                        Label("User Account", systemImage: currentUserService.isSignedIn ? "person.fill" : "person")
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
        privateMessageStore: PrivateMessageStore()              // loading empty because private messages not used yet
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

            // This is a Placeholder-Test View, with test data
            Section(header: Text("Announcements")) {
                ListableStoreView(store: ListableCloudStore<Announcement>.testLoaded(with: Announcement.testObjects), showDividers: false)
            }
            
            // This is a Placeholder-Test View
            FormCaptureView(
                viewModel: FormCaptureViewModel<StructSample>.configured(),
                showHeader: false,
                onSubmit: { result in
                    print("Captured StructSample: \(result)")
                }
            )
                .padding(.horizontal)
                .background(Color(.systemGroupedBackground))
                .cornerRadius(6)
                .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
            
            // This is a Placeholder-Test View, with test data
            ListableStoreSectionView(store: ListableCloudStore<Announcement>.testLoaded(with: Announcement.testObjects))
            
            // This is a Placeholder-Test View disappearing when there is no data!
            ListableStoreSectionView(store: ListableCloudStore<Announcement>.testEmpty())
            
        }
        .dynamicTypeSize(...ViewConfiguration.dynamicSizeMax)
        .environment(\.font, Font.body)
    }
}
#endif
