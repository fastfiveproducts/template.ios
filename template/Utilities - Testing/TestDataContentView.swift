//
//  TestDataContentView.swift
//
//  Created by Pete Maiser, January 2025 through May 2025
//      made availble here:
//      https://github.com/fastfiveproducts/template.ios
//      per terms of the MIT License
//      changes should be rare; it is recommended changes are applied to the template
//      and the entire file compared-and-then-replaced here if/as appropriate
//


#if DEBUG
import SwiftUI

struct TestDataContentView<Content: View>: View {
    @StateObject var hvm: HomeViewModel = HomeViewModelTestData.shared
    @StateObject var currentUser: CurrentUser = CurrentUserTestData.shared
    @ViewBuilder let content: () -> Content
    
    var body: some View {
        VStack {
            content()
        }
        .onChange(of: currentUser.isSignedIn) {
            if currentUser.isSignedIn {
                Task {
                    hvm.fetchTournaments()
                }
            }
        }
        .dynamicTypeSize(...ViewConfiguration.dynamicSizeMax)
        .environment(\.font, Font.body)
        .environmentObject(hvm)
        .environmentObject(currentUser)
    }
}

#Preview ("BracketView") {
    TestDataContentView {
        HomeView(viewModel: HomeViewModelTestData.shared, currentUser: CurrentUserTestData.sharedSignedIn)
    }
}
#endif
