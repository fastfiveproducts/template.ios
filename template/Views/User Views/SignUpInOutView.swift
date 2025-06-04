//
//  SignUpSignInSignOutView.swift
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

struct SignUpInOutView: View, DebugPrintable {
    @ObservedObject var viewModel : UserAccountViewModel
    @ObservedObject var currentUserService: CurrentUserService
    @State var createAccountMode: Bool
    
    @FocusState private var focusedField: Field?
    private func nextField() {
        switch focusedField {
            case .username:
                focusedField = .password
            case .password:
                focusedField = .button
            case .button:
                focusedField = .none
            case .none:
                focusedField = .none
        }
    }
    private enum Field: Hashable { case username; case password; case button }
    
    var body: some View {
        
        Section(header: Text(currentUserService.isSignedIn ? "Signed-In User" : ( createAccountMode ? "Sign-Up" : "Sign-In or Sign-Up"))) {
            if currentUserService.isSignedIn {
                Text(currentUserService.userAccount.profile.displayName)
                LabeledContent {
                    Text(currentUserService.userAccount.email)
                } label: { Text("email address:") }
                    .labeledContentStyle(TopLabeledContentStyle())
                Button(action: toggleLogin) {
                    Text(currentUserService.isSignedIn ? "Sign Out" : "Submit")
                }
                .frame(maxWidth: .infinity)
                .foregroundColor(.white)
                .listRowBackground(Color.accentColor)
            }
            else {
                LabeledContent {
                    TextField(text: $viewModel.capturedEmailText, prompt: Text(currentUserService.isSignedIn ? currentUserService.userAccount.email : "sign-in or sign-up email address")) {}
                        .disabled(createAccountMode)
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                        .disableAutocorrection(true)
                        .focused($focusedField, equals: .username)
                        .onTapGesture { nextField() }
                        .onSubmit { nextField() }
                } label: { Text("email address:") }
                    .labeledContentStyle(TopLabeledContentStyle())
                
                if createAccountMode {
                    LabeledContent {
                        SecureField(text: $viewModel.capturedPasswordText, prompt: Text("password")) {}
                            .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                            .keyboardType(.emailAddress)
                            .disableAutocorrection(true)
                            .focused($focusedField, equals: .password)
                            .onTapGesture { nextField() }
                            .onSubmit { toggleLogin() }
                    } label: { Text("password:") }
                        .labeledContentStyle(TopLabeledContentStyle())
                } else {
                    LabeledContent {
                        SecureField(text: $viewModel.capturedPasswordText, prompt: Text("password")) {}
                            .disabled(currentUserService.isSignedIn)
                            .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                            .keyboardType(.emailAddress)
                            .disableAutocorrection(true)
                            .focused($focusedField, equals: .password)
                            .onTapGesture { toggleLogin() }
                            .onSubmit { toggleLogin() }
                    } label: { Text("password:") }
                        .labeledContentStyle(TopLabeledContentStyle())
                    Button(action: toggleLogin) {
                        Text(currentUserService.isSignedIn ? "Sign Out" : "Submit")
                    }
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.white)
                    .listRowBackground(Color.accentColor)
                }
            }
            

        }
        .onAppear {focusedField = .username}
        //        .alert("Error", error: $viewModel.error)  // TODO not sure if I need this here or the one in the parent view is enough
        
        Section {
            if currentUserService.isSigningIn {
                HStack {
                    Text("Checking Email Address...")
                    ProgressView()
                    Spacer()
                }
            }
        }
        
        if createAccountMode {
            CreateAccountView(
                viewModel: viewModel,
                currentUserService: currentUserService
            )
        }
    }
//        .alert("Error", error: $viewModel.error)  // TODO not sure if I need this here or the one in the parent view is enough
}

private extension SignUpInOutView {
    private func toggleLogin() {
        if currentUserService.isSignedIn {
            do {
                try CurrentUserService.shared.signOut()
            } catch {
                debugprint("(View) Error signing out of User Account: \(error)")
                viewModel.error = error
            }
        } else if viewModel.isReadyToSignIn() {
            Task {
                do {
                    let uid = try await currentUserService.signInExistingUser(
                                                email: viewModel.capturedEmailText,
                                                password: viewModel.capturedPasswordText)
                    debugprint("(View) User \(uid) signed in")
                } catch {
                    if error as! SignInError == SignInError.userNotFound {
                        createAccountMode = true
                    } else {
                        debugprint("(View) Error signing into User Account: \(error)")
                        viewModel.error = error
                        throw error
                    }
                }
            }
        }
    }
}


#if DEBUG
#Preview ("test-data signed-in") {
    let currentUserService = CurrentUserTestService.sharedSignedIn
    Form {
        SignUpInOutView(
            viewModel: UserAccountViewModel(),
            currentUserService: currentUserService,
            createAccountMode: false
        )
    }
    .dynamicTypeSize(...ViewConfiguration.dynamicSizeMax)
    .environment(\.font, Font.body)
}
#Preview ("test-data signed-out") {
    let currentUserService = CurrentUserTestService.sharedSignedOut
    Form {
        SignUpInOutView(
            viewModel: UserAccountViewModel(),
            currentUserService: currentUserService,
            createAccountMode: false
        )
    }
    .dynamicTypeSize(...ViewConfiguration.dynamicSizeMax)
    .environment(\.font, Font.body)
}
#Preview ("test-data creating-account") {
    let currentUserService = CurrentUserTestService.sharedSignedOut
    Form {
        SignUpInOutView(
            viewModel: UserAccountViewModel(),
            currentUserService: currentUserService,
            createAccountMode: true
        )
    }
    .dynamicTypeSize(...ViewConfiguration.dynamicSizeMax)
    .environment(\.font, Font.body)
}
#endif
