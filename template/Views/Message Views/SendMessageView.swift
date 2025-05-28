//
//  SendMessageView.swift
//
//  Created by Pete Maiser, January 2025 through May 2025
//      made availble here:
//      https://github.com/fastfiveproducts/template.ios
//      per terms of the MIT License
//      changes should be rare; it is recommended changes are applied to the template
//      and the entire file compared-and-then-replaced here if/as appropriate
//

import SwiftUI

struct SendMessageView<T: Message>: View {
    @StateObject var viewModel: SendMessageViewModel<T>
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        
        NavigationView {
            Form {
                Section("\(CurrentUser.shared.user.profile.displayName):") {
                    TextEditor(text: $viewModel.captureCandidate.content)
                        .autocapitalization(.none)
                        .multilineTextAlignment(.leading)
                }
                Button(action: viewModel.submit) {
                    if viewModel.isWorking {
                        ProgressView()
                    } else {
                        Text("Create " + viewModel.captureCandidate.typeDescription)
                    }
                }
                .font(.headline)
                .frame(maxWidth: .infinity)
                .foregroundColor(.white)
                .padding()
                .listRowBackground(Color.accentColor)
            }
            .onSubmit(viewModel.submit)
            .onChange(of: viewModel.isWorking) {
                guard !viewModel.isWorking, viewModel.error == nil else { return }
                dismiss()
            }
            .navigationTitle("New " + viewModel.captureCandidate.typeDescription)
        }
        .disabled(viewModel.isWorking)
        .alert("Cannot Create " + viewModel.captureCandidate.typeDescription, error: $viewModel.error)
    }
}


#if DEBUG
#Preview ("Create Comment") {
    SendMessageView(viewModel: HomeViewModelTestData.shared.makeCreatePublicCommentViewModel())
}

#Preview ("Create Message") {
    SendMessageView(viewModel: HomeViewModelTestData.shared.makeCreatePrivateMessageViewModel())
}
#endif
