//
//  CreateMessageViewModel.swift
//  bd.ios
//
//  Created by Pete Maiser on 2/18/25.
//

import Foundation

@MainActor
class SendMessageViewModel<T: Message>: SignInOutObserver {
    
    // Status and Modes
    @Published var error: Error?
    @Published var isWorking = false

    // Capture Fields
    @Published var captureCandidate: MessageCandidate
    
    // Submit Prep
    typealias Translate = (MessageCandidate) throws -> T
    private let translate: Translate
    
    // Submit Action
    typealias Action = (T) async throws -> Void
    private let action: Action
        
    init(captureCandidate: MessageCandidate, translate: @escaping Translate, action: @escaping Action) {
        self.captureCandidate = captureCandidate
        self.translate = translate
        self.action = action
    }
    
    func submit() {
        Task {
            await handleSubmit()
        }
    }
        
    private func handleSubmit() async {
        isWorking = true
        do {
            let sendCandidate = try translate(captureCandidate)
            try await action(sendCandidate)
        } catch {
            debugprint("Cloud Error creating \(T.typeDescription): \(error)")
            self.error = error
        }
        isWorking = false
    }
    
}
