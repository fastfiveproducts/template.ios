//
//  UserAccountViewModel.swift
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
class UserAccountViewModel: ObservableObject, DebugPrintable
{
    // Status
    @Published private(set) var statusText = ""
    @Published var error: Error?
    @Published var createAccountMode = false
    
    init(createAccountMode: Bool = false) {
        self.createAccountMode = createAccountMode
    }
    
    // Capture
    var capturedEmailText = ""
    var capturedPhoneNumberText = ""
    var capturedPasswordText = ""
    var capturedPasswordMatchText = ""
    var capturedDisplayNameText = ""
    @Published var notRobot: Bool = false {
        didSet {
            statusText = ("")
        }
    }
    var dislikesRobots: Bool = false

    // Validation
    func isReadyToSignIn() -> Bool {
        statusText = ""
        var isReady = true
        
        if capturedEmailText.isEmpty {
            statusText = ("Please enter your sign-in email")
            isReady = false
        } else if capturedPasswordText.isEmpty {
            statusText = ("Please re-enter your password")
            isReady = false
        }
        return isReady
    }

    func isReadyToCreateAccount() -> Bool {
        statusText = ""
        var isReady = true
        
        if capturedEmailText.isEmpty {
            statusText = ("Please enter your sign-in email")
            isReady = false
        } else if capturedPasswordText.isEmpty {
            statusText = ("Please enter your password")
            isReady = false
        } else if capturedPasswordMatchText.isEmpty {
            statusText = ("Please enter your password match")
            isReady = false
        } else if capturedDisplayNameText.isEmpty {
            statusText = ("Please enter your display name")
            isReady = false
        }
        
        if RestrictedWordStore.shared.containsRestrictedWords(capturedDisplayNameText) {
            statusText = "Display Name matched one or more keywords on our Restricted Text List. Please adjust.";
            isReady = false
        }
        return isReady
    }
    
    // Create
    var createdUserId: String = ""
    var accountCandidate: UserAccountCandidate {
        return UserAccountCandidate(uid: createdUserId, displayName: capturedDisplayNameText, photoUrl: "")
    }

}
