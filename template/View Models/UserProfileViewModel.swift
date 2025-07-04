//
//  UserProfileViewModel.swift
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


import Foundation

@MainActor
class UserProfileViewModel: ObservableObject, DebugPrintable
{
    // Status and Modes
    @Published var error: Error?
    @Published private(set) var statusText = ""
    @Published var loginUserMode = false {
        didSet  {
            if loginUserMode == true {
                createUserMode = false
                statusText = ("")
            } else if !CurrentUserService.shared.isSignedIn {
                statusText = ("")
            }
        }
    }
    @Published var createUserMode = false {
        didSet  {
            if createUserMode == true {
                capturedSignInEmailText = ""
                loginUserMode = false
                statusText = ("")
                Task {
                    await RestrictedTextStore.shared.enableRestrictedText()
                }
            }
        }
    }
    
    // Capture Fields
    var capturedSignInEmailText = ""
    var capturedPhoneNumberText = ""
    @Published var textFieldList: [TextConfiguration]
    @Published var notRobot: Bool = false {
        didSet {
            statusText = ("")
        }
    }

    // Capture Field Helpers
    func getTextFieldIndex(withName name: String) -> Int {
        for i in textFieldList.startIndex..<textFieldList.endIndex {
            if textFieldList[i].name == name { return i }
        }
        textFieldList.append(TextConfiguration(name: name, prompt: "this field is not supported"))
        return textFieldList.endIndex - 1
    }
    
    private func resetCreateFields() {
        for i in textFieldList.startIndex..<textFieldList.endIndex {
            textFieldList[i].capturedText = ""
        }
        notRobot = false
        loginUserMode = true
    }
        
    // Initialize and Notification-Handling
    init() {
        textFieldList = [
            TextConfiguration(name: "sign-in email address", prompt: "required: Email Address", autoCapitalize: false, autoDisplay: false),
            TextConfiguration(name: "sign-in phone number", prompt: "required:  Phone Number", autoCapitalize: false, autoDisplay: false),
            TextConfiguration(name: "display name", prompt: "required: Display Name", autoCapitalize: false, autoDisplay: true)
        ]
    }
           
    // Features - log in, log out
    func logIn() async throws {
        if capturedSignInEmailText.isEmpty {
            statusText = ("Please enter your sign-in email")
        } else if capturedPhoneNumberText.isEmpty {
            statusText = ("Please re-enter your phone number")
        } else {
            statusText = ""
            do {
                try await CurrentUserService.shared.requestSignInLinkEmail(toEmail: capturedSignInEmailText)
            } catch {
                debugprint("(ViewModel) Error signing into User Account: \(error)")
                self.error = error
                throw error
            }
        }
    }
    
    func logOut() {
        do {
            try CurrentUserService.shared.signOut()
        } catch {
            self.error = error
        }
    }
    
    // Features - create user
//    func requestCreateUser() async throws {
//        if createFieldsValidated() {
//            
//            let userCandidate = UserCandidate(
//                email: textFieldList[getTextFieldIndex(withName: "sign-in email address")].capturedText,
//                phoneNumber: textFieldList[getTextFieldIndex(withName: "sign-in phone number")].capturedText,
//                displayName: textFieldList[getTextFieldIndex(withName: "display name")].capturedText
//            )
//            
//            do {
//                try await CurrentUserService.shared.requestNewAccountWithCandidate(userCandidate)
//            } catch {
//                debugprint("(ViewModel) Error initiating User Account creation: \(error)")
//                self.error = error
//                throw error
//            }
//            
//        }
//    }
    private func createFieldsValidated() -> Bool {
        for i in textFieldList.startIndex..<textFieldList.endIndex {
            if textFieldList[i].required {
                if textFieldList[i].capturedText.isEmpty {
                    statusText = ("Please enter \(textFieldList[i].name)");
                    return false
                }
            }
        }
        for i in textFieldList.startIndex..<textFieldList.endIndex {
            if textFieldList[i].checkRestrictedText {
                if RestrictedTextStore.shared.containsRestrictedText(textFieldList[i].capturedText) {
                    statusText = "Entered \(textFieldList[i].name) matched one or more keywords on our Restricted Text List. Please adjust.";
                    return false
                }
            }
        }
        statusText = ""
        return true
    }
}
