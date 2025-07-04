//
//  UserAccountView.swift
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

struct UserAccountView: View {
    @StateObject var viewModel: UserAccountViewModel
    @ObservedObject var currentUserService: CurrentUserService

    @Namespace var createUserViewId
          
    var body: some View {
        VStack {
            Form {
                SignUpInOutView(viewModel: viewModel, currentUserService: currentUserService)
                if currentUserService.isSignedIn && !viewModel.showStatusMode {
                    UserAccountProfileView()
                    UserAssociationView()
                    UserDemographicsView()
                }
            }
        }
        .dynamicTypeSize(...ViewConfiguration.dynamicSizeMax)
        .environment(\.font, Font.body)
        .alert("Error", error: $viewModel.error)
    
        Text(viewModel.statusText)
    }
}


#if DEBUG
#Preview ("test-data signed-in") {
    let currentUserService = CurrentUserTestService.sharedSignedIn
    UserAccountView(
        viewModel: UserAccountViewModel(),
        currentUserService: currentUserService
    )
}
#Preview ("test-data signed-out") {
    let currentUserService = CurrentUserTestService.sharedSignedOut
    UserAccountView(
        viewModel: UserAccountViewModel(),
        currentUserService: currentUserService
    )
}
#endif
