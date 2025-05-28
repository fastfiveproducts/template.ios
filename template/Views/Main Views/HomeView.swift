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
    @StateObject var viewModel: HomeViewModel
    @StateObject var currentUser: CurrentUser
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Welcome")) {
                    SimpleListView(store: AnnouncementStore.shared)
                }
                                                            
                Section(header: Text("Home")) {
                    VStack {
                        Image(systemName: "globe")
                            .imageScale(.large)
                            .foregroundStyle(.tint)
                        Text("Hello, world!")
                    }
                }
            }
            .padding()
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("Template")
                        .font(.title)
                }
                                
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: UserProfileView(viewModel: UserProfileViewModel()), label: {
                        currentUser.isSignedIn ? Image(systemName: "person.fill"):Image(systemName: "person")
                    })
                    .buttonStyle(BorderlessButtonStyle())
                }
            }
            .onAppear() {
                // note this is called every time the view appears on the screen
                viewModel.fetchAnnouncements()
            }
            .onChange(of: currentUser.isSignedIn) {
                if currentUser.isSignedIn {
                    // ...do stuff
                }
            }
        } // NavigationStack
        .alert("Error", error: $currentUser.authError)
        .dynamicTypeSize(...ViewConfiguration.dynamicSizeMax)
        .environment(\.font, Font.body)
        .environmentObject(viewModel)
        .environmentObject(currentUser)
    }
}


#if DEBUG
#Preview ("test data") {
    HomeView(viewModel: HomeViewModelTestData.shared, currentUser: CurrentUserTestData.sharedSignedIn)
}

#Preview ("live data") {
    HomeView(viewModel: HomeViewModel(currentUser: CurrentUser.shared), currentUser: CurrentUser.shared)
}
#endif
