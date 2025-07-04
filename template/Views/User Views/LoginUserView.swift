//
//  LogInUserView.swift
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

struct LoginUserView: View, DebugPrintable {
    @EnvironmentObject var currentUser: CurrentUserService
    @EnvironmentObject var viewModel: UserProfileViewModel
    
    private enum Field: Hashable { case username; case button }
    @FocusState private var focusedField: Field?
    private func nextField() {
        switch focusedField {
            case .username:
                focusedField = .button
            case .button:
                focusedField = .none
            case .none:
                focusedField = .none
        }
    }
    
    var body: some View {
        
        Section(header: Text(currentUser.isSignedIn ? "signed in user" : "sign in user")) {
        
            if currentUser.isSignedIn {
                Text(currentUser.user.profile.displayName)
            } else {
                LabeledContent {
                    TextField(text: $viewModel.capturedSignInEmailText, prompt: Text(currentUser.isSignedIn ? currentUser.user.email : "sign-in email address")) {}
                        .disabled(currentUser.isSignedIn)
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                        .disableAutocorrection(true)
                        .onSubmit {
                            nextField()
                            toggleLogin()
                        }
                        .focused($focusedField, equals: .username)
                } label: { Text("sign-in email address") }
                    .labeledContentStyle(TopLabeledContentStyle())
            }
            
            if !currentUser.isWaitingOnEmailVerification && !currentUser.isSigningIn {
                Button(action: toggleLogin) {
                    Text(currentUser.isSignedIn ? "Sign Out" : "Submit")
                }
                .focused($focusedField, equals: .button)
            }
        }
        .onAppear {focusedField = .username}
        .alert("Error", error: $viewModel.error)
        .alert("Error", error: $currentUser.authError)
        
        Section {
            if currentUser.isWaitingOnEmailVerification {
                HStack {
                    Text("Check your Email and click the link to verify your email address.")
                    Spacer()
                }
            }
            else if currentUser.isSigningIn {
                HStack {
                    Text("Signing In Verified User...")
                    ProgressView()
                    Spacer()
                }
            }
        }
    }
}

private extension LoginUserView {
    private func toggleLogin() {
        if currentUser.isSignedIn {
            viewModel.logOut()
        } else {
            Task {
                do {
                    try await viewModel.logIn()
                } catch {
                    debugprint("(View) Error signing into User Account: \(error)")
                }
            }
        }
    }
}


#if DEBUG
#Preview {
    Form { LoginUserView() }
    .dynamicTypeSize(...ViewConfiguration.dynamicSizeMax)
    .environment(\.font, Font.body)
    .environmentObject(CurrentUserService.shared)
    .environmentObject(UserProfileViewModel())
}
#endif
