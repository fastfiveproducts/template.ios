//
//  CreateAccountView.swift
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

struct CreateAccountView: View, DebugPrintable {
    @ObservedObject var viewModel : UserAccountViewModel
    @ObservedObject var currentUserService: CurrentUserService
    
    @FocusState private var focusedField: Field?
    private func nextField() {
        switch focusedField {
            case .password:
                focusedField = .displayName
            case .displayName:
                focusedField = .none
            case .button:
                focusedField = .none
            case .none:
                focusedField = .none
        }
    }
    private enum Field: Hashable { case password; case displayName, button}

    var body: some View {
        
        Section(header: Text("Create New Account")) {
            LabeledContent {
                SecureField(text: $viewModel.capturedPasswordMatchText, prompt: Text("password")) {}
                    .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                    .keyboardType(.emailAddress)
                    .disableAutocorrection(true)
                    .focused($focusedField, equals: .password)
                    .onTapGesture { nextField() }
                    .onSubmit { nextField() }
            } label: { Text("enter password again:") }
                .labeledContentStyle(TopLabeledContentStyle())
            
            LabeledContent {
                TextField(text: $viewModel.capturedDisplayNameText) {}
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                    .disableAutocorrection(true)
                    .focused($focusedField, equals: .displayName)
                    .onTapGesture { nextField() }
                    .onSubmit { nextField() }
            } label: { Text("enter a Display Name:") }
                .labeledContentStyle(TopLabeledContentStyle())
            
            Toggle(isOn: $viewModel.notRobot) {
                Text("I am not a Robot")
            }
            Toggle(isOn: $viewModel.dislikesRobots) {
                Text("I don't even like Robots")
            }

            Button(action: startOver) {
                Text("Start Over")
            }
            .frame(maxWidth: .infinity)
            .foregroundColor(.white)
            .listRowBackground(Color.accentColor)
            
            Button(action: createAccount) {
                Text("Submit")
            }
            .frame(maxWidth: .infinity)
            .foregroundColor(.white)
            .listRowBackground(Color.accentColor)
            .disabled(!viewModel.notRobot || currentUserService.isCreatingUser || currentUserService.isCreatingUserAccount)
            
        }
        .onAppear { focusedField = .password }
        .onChange(of: viewModel.notRobot) {
            if viewModel.notRobot == true {
                focusedField = .button
            }
        }
        .onSubmit {
            if (viewModel.notRobot) {
                createAccount() }
        }
        // .alert("Error", error: $viewModel.error)  // TODO: not sure if I need this here or the one in the parent view is enough
        
        Section {
            if currentUserService.isCreatingUser {
                HStack {
                    Text("Creating User...")
                    ProgressView()
                    Spacer()
                }
            } else if currentUserService.isCreatingUserAccount {
                HStack {
                    Text("Creating User Profile...")
                    ProgressView()
                    Spacer()
                }
            } else if currentUserService.isUpdatingUserAccount {
                HStack {
                    Text("Setting Display Name...")
                    ProgressView()
                    Spacer()
                }
            }
        }
    }
}

private extension CreateAccountView {
    
    private func startOver() {
        debugprint("(View) startOver called")
    }
       
    private func createAccount() {
        debugprint("(View) createAccount called")
        if viewModel.isReadyToCreateAccount() {
            Task {
                
                // create the user in the Auth system first
                do {
                    viewModel.createdUserId = try await currentUserService.signInOrCreateUser(
                        email: viewModel.capturedEmailText,
                        password: viewModel.capturedPasswordText)
                } catch {
                    debugprint("(View) Cloud Error creating User in the Authentication system: \(error)")
                    viewModel.error = error
                    throw error
                }
                                
                // create the user in the Application system
                // use the email address as the display name text to start,
                // making the app functional even if the user's chosen display name is taken
                do {
                    try await currentUserService.createUserAccount(viewModel.accountCandidate, displayNameTextOverride: viewModel.capturedEmailText)
                } catch {
                    debugprint("(View) User \(viewModel.createdUserId) created in the Authentication system, but Clould error creating User Account: \(error)")
                    viewModel.error = error
                    throw AccountCreationError.userAccountCreationIncomplete(error)
                }
                
                // create the user's chosen Display Name
                do {
                    try await currentUserService.createUserDisplayName(viewModel.accountCandidate.displayName)
                } catch {
                    debugprint("(View) User \(viewModel.createdUserId) created and Account initialized, but Clould error creating User Display Name: \(error)")
                    viewModel.error = error
                    throw AccountCreationError.userDisplayNameCreationFailed
                }
                
                // User Account is sufficiently created such that we will no long throw errors,
                // so do less-critial tasks and clean-up
                defer {
                    viewModel.capturedPasswordText = ""
                    viewModel.createAccountMode = false
                }
                do {
                    try await currentUserService.setUserDisplayName(viewModel.accountCandidate.displayName)
                } catch {
                    debugprint("(View) User \(viewModel.createdUserId) created, Account initialized, Display Name created, but Cloud Error setting Display Name: \(error)")
                    viewModel.error = error
                }
            }
        }
    }
}


#if DEBUG
#Preview ("test-data signed-out") {
    let currentUserService = CurrentUserTestService.sharedSignedOut
    ScrollViewReader { proxy in
        Form {
            CreateAccountView(
                viewModel: UserAccountViewModel(),
                currentUserService: currentUserService
            )
        }
        .dynamicTypeSize(...ViewConfiguration.dynamicSizeMax)
        .environment(\.font, Font.body)
    }
}
#Preview ("test-data creating-user") {
    let currentUserService = CurrentUserTestService.sharedCreatingUser
    ScrollViewReader { proxy in
        Form {
            CreateAccountView(
                viewModel: UserAccountViewModel(),
                currentUserService: currentUserService
            )
        }
        .dynamicTypeSize(...ViewConfiguration.dynamicSizeMax)
        .environment(\.font, Font.body)
        
        Spacer()
        Button(action: currentUserService.nextCreateState) {
            Text("Next State")
        }
    }
}
#endif

