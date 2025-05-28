//
//  UserProfileView.swift
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

struct UserProfileView: View {
    @StateObject var viewModel: UserProfileViewModel
    @EnvironmentObject var currentUser: CurrentUserService
    
    @Environment(\.dismiss) private var dismiss

    @Namespace var createUserViewId
          
    var body: some View {
        VStack {
            ScrollViewReader { proxy in
                Form {
                    // most typical case - exsting User is logged in
                    if (currentUser.isSignedIn == true)
                    {
                        LoginUserView()
                    }
                    
                    // if a User is not logged-in pop choices
                    else {
                        Button(action: toggleLoginUserView) {
                            Text("Sign In:  as existing user")
                        }
                        .alignmentGuide(.listRowSeparatorLeading) {_ in -20}
                        Button(action: toggleCreateUserView) {
                            Text("Sign In:  as first-time user")
                        }
                    }
                    
                    // apply choice
                    if (currentUser.isSignedIn == false)
                    {
                        if viewModel.loginUserMode == true {
                            LoginUserView()
                        }
                        if viewModel.createUserMode == true {
                            CreateUserView()
                                .id(createUserViewId)
                        }
                    }
                }
                .onChange(of: viewModel.notRobot) {
                    if viewModel.notRobot == true {
                        proxy.scrollTo(createUserViewId, anchor: .top)
                    }
                }
            }
            Text(viewModel.statusText)
        }
        .onChange(of: currentUser.isCreatingUser) {
            if currentUser.isCreatingUser,
               currentUser.isSignedIn == true
            {
                dismiss()
            }
        }
        .dynamicTypeSize(...ViewConfiguration.dynamicSizeMax)
        .environment(\.font, Font.body)
        .environmentObject(viewModel)
    }
}

private extension UserProfileView {
    private func toggleLoginUserView() {
        viewModel.loginUserMode.toggle()
    }
    private func toggleCreateUserView() {
        viewModel.createUserMode.toggle()
    }
}


#if DEBUG
#Preview ("test data signed-in") {
    UserProfileView(viewModel: UserProfileViewModel())
        .environmentObject(CurrentUserTestData.sharedSignedIn)
}

#Preview ("test data signed-out") {
    UserProfileView(viewModel: UserProfileViewModel())
        .environmentObject(CurrentUserTestData.sharedSignedOut)
}

#Preview ("live data") {
    UserProfileView(viewModel: UserProfileViewModel())
        .environmentObject(CurrentUserService.shared)
}
#endif
