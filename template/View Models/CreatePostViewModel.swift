//
//  CreatePostViewModel.swift
//
//  Created by Pete Maiser, January 2025 through May 2025
//      made availble here:
//      https://github.com/fastfiveproducts/template.ios
//      per terms of the MIT License
//      changes should be rare; it is recommended changes are applied to the template
//      and the entire file compared-and-then-replaced here if/as appropriate
//

import Foundation

@MainActor
class CreatePostViewModel<T: Post>: ObservableObject, DebugPrintable {
    
    // Status
    @Published private(set) var statusText = ""
    @Published var error: Error?
    @Published var isWorking = false

    // Capture
    var toUser: UserKey = UserKey.blankUser
    var capturedTitleText = ""
    var capturedContentText = ""
    
    // Validation
    func isReadyToSubmitComment() -> Bool {
        statusText = ""
        var isReady = true
        
        if capturedContentText.isEmpty {
            statusText = ("No Content Entered")
            isReady = false
        }
        
        if RestrictedWordStore.shared.containsRestrictedWords(capturedContentText) {
            statusText = "Content matched one or more keywords on our Restricted Text List. Please adjust.";
            isReady = false
        }
        
        return isReady
    }
    
    func isReadyToSendMessage() -> Bool {
        statusText = ""
        var isReady = true
        
        if capturedTitleText.isEmpty {
            statusText = ("No Subject Entered")
            isReady = false
        }
        if capturedContentText.isEmpty {
            statusText = ("No Content Entered")
            isReady = false
        }

        if RestrictedWordStore.shared.containsRestrictedWords(capturedTitleText) {
            statusText = "Subject matched one or more keywords on our Restricted Text List. Please adjust.";
            isReady = false
        }
        if RestrictedWordStore.shared.containsRestrictedWords(capturedContentText) {
            statusText = "Content matched one or more keywords on our Restricted Text List. Please adjust.";
            isReady = false
        }
        
        return isReady
    }
    
    // Create
    var postCandidate = PostCandidate.placeholder
    var createdPost = T.placeholder
}
