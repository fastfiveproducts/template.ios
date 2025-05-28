//
//  SignInOutObserver.swift
//
//  Created by Pete Maiser, January 2025 through May 2025
//      made availble here:
//      https://github.com/fastfiveproducts/template.ios
//      per terms of the MIT License
//      changes should be rare; it is recommended changes are applied to the template
//      and the entire file compared-and-then-replaced here if/as appropriate
//


import Foundation
import Combine

@MainActor
class SignInOutObserver: ObservableObject, DebugPrintable {

    // Subscribe to the sign-in publisher so we can refresh
    // data when a user signs-in
    private var signInPublisher: AnyCancellable?
    
    // Subscribe to the sign-out publisher so we can reset
    // data when a user signs-out
    private var signOutPublisher: AnyCancellable?
    
    init() {
        let currentUser = CurrentUserService.shared
        signInPublisher = currentUser.signInPublisher.sink { [weak self] in
            self?.postSignInSetup()
        }
        signOutPublisher = currentUser.signOutPublisher.sink { [weak self] in
             self?.postSignOutCleanup()
         }
    }
    
    deinit {
        signInPublisher?.cancel()
        signOutPublisher?.cancel()
    }
    
    func postSignInSetup() {
        debugprint ("setup after user sign-in")
    }
    
    // cleanup user-session dependent data after user sign-out
    func postSignOutCleanup() {
        debugprint ("cleaned-up after user sign-out")
    }
}
