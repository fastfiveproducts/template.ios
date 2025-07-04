//
//  CreateUserView.swift
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

struct CreateUserView: View, DebugPrintable {
    @EnvironmentObject var viewModel : UserProfileViewModel
    @EnvironmentObject var currentUser: CurrentUser
    
    @State private var userCreationError: Error?
    
    @FocusState private var focusedFieldIndex: Int?
    private func nextField() {
        if focusedFieldIndex == viewModel.textFieldList.count - 1 {
            if viewModel.notRobot {createUser() }
        } else {
            focusedFieldIndex = (focusedFieldIndex ?? -1) + 1
        }
    }

    var body: some View {
        
        Section(header: Text("Create New User")) {
            displayLabeledTextFieldForEmail(atIndex: viewModel.getTextFieldIndex(withName: "sign-in email address"))
        }
        
        Section {
            ForEach(viewModel.textFieldList.indices, id: \.self) { i in
                if viewModel.textFieldList[i].autoDisplay {
                    displayLabeledTextField(atIndex: i)
                }
            }
            
            if !currentUser.isCreatingUser {
                Toggle(isOn: $viewModel.notRobot) {
                    Text("I am not a Robot")
                }
            }
            
            if !currentUser.isCreatingUser && viewModel.notRobot {
                HStack {
                    Button(action: createUser) {
                        HStack {
                            Text("Submit")
                        }
                    }
                    Spacer()
                }
            }
        }
        .onAppear {
            focusedFieldIndex = 0
        }
        .onChange(of: viewModel.notRobot) {
            if viewModel.notRobot == true {
                focusedFieldIndex = nil
            }
        }
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
            else if currentUser.isCreatingUserProfile {
                HStack {
                    Text("Creating New User Profile...")
                    ProgressView()
                    Spacer()
                }
            }
            else if currentUser.isCreatingUser {
                HStack {
                    Text("Creating User...")
                    ProgressView()
                    Spacer()
                }
            }
        }
    }
}

private extension CreateUserView {
    // TODO: I don't need three of these...maybe two
    private func displayLabeledTextFieldForEmail(atIndex i: Int) -> some View {
        LabeledContent {
            TextField(viewModel.textFieldList[i].prompt, text: $viewModel.textFieldList[i].capturedText)
                .textInputAutocapitalization(viewModel.textFieldList[i].autoCapitalization)
                .disableAutocorrection(true)
                .keyboardType(.emailAddress)
                .focused($focusedFieldIndex, equals: i)
                .onTapGesture { focusedFieldIndex = i }
                .onSubmit {nextField()}
        } label: { Text(viewModel.textFieldList[i].name) }
            .labeledContentStyle(TopLabeledContentStyle())
    }
    private func displayLabeledTextField(atIndex i: Int) -> some View {
        LabeledContent {
            TextField(viewModel.textFieldList[i].prompt, text: $viewModel.textFieldList[i].capturedText)
                .textInputAutocapitalization(viewModel.textFieldList[i].autoCapitalization)
                .disableAutocorrection(true)
                .keyboardType(.emailAddress)
                .focused($focusedFieldIndex, equals: i)
                .onTapGesture { focusedFieldIndex = i }
                .onSubmit {nextField()}
        } label: { Text(viewModel.textFieldList[i].name) }
            .labeledContentStyle(TopLabeledContentStyle())
    }
    private func displayLabeledSecureField(atIndex i: Int) -> some View {
        LabeledContent {
            SecureField(text: $viewModel.textFieldList[i].capturedText, prompt: Text(viewModel.textFieldList[i].prompt)) {}
                .textInputAutocapitalization(viewModel.textFieldList[i].autoCapitalization)
                .disableAutocorrection(true)
                .focused($focusedFieldIndex, equals: i)
                .onTapGesture { focusedFieldIndex = i }
                .onSubmit { nextField() }
        } label: { Text(viewModel.textFieldList[i].name) }
            .labeledContentStyle(TopLabeledContentStyle())
    }
       
    private func createUser() {
        Task {
            do {
                try await viewModel.requestCreateUser()
            } catch {
                debugprint("(View) Error creating User Account: \(error)")
            }
        }
    }
}


#if DEBUG
#Preview {
    ScrollViewReader { proxy in
        Form {
            CreateUserView()
                .environmentObject(UserProfileViewModel())
                .environmentObject(CurrentUserTestData.sharedSignedIn)
        }
        .dynamicTypeSize(...ViewConfiguration.dynamicSizeMax)
        .environment(\.font, Font.body)
        .environmentObject(UserProfileViewModel())
    }
}
#endif
