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
            .disabled(!viewModel.notRobot || currentUserService.isCreatingUser || currentUserService.isCreatingUserProfile)
            
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
            }
            else if currentUserService.isCreatingUserProfile {
                HStack {
                    Text("Creating New User Profile...")
                    ProgressView()
                    Spacer()
                }
            }
        }
    }
}

private extension CreateAccountView {
    
    private func startOver() {
        debugprint("(View) createAccount called")
    }
       
    private func createAccount() {
        debugprint("(View) createAccount called")
        if viewModel.isReadyToCreateAccount() {
            Task {
                do {
                    viewModel.createdUserId = try await currentUserService.signInOrCreateUser(
                        email: viewModel.capturedEmailText,
                        password: viewModel.capturedPasswordText)
                } catch {
                    debugprint("(View) Cloud Error creating User Account: \(error)")
                    viewModel.error = error
                    throw error
                }
                do {
                    try await currentUserService.createUserProfile(viewModel.profileCandidate)
                } catch {
                    debugprint("(View) User \(viewModel.createdUserId) created, but Clould error creating User Profile: \(error)")
                    viewModel.error = error
                    throw AccountCreationError.userProfileCreationIncomplete(error)
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

