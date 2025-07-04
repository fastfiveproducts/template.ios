//
//  UserMessagesView.swift
//  bd.ios
//
//  Created by Pete Maiser on 3/1/25.
//

import SwiftUI

struct MyMessagesView<T: Message>: View {
    @StateObject var viewModel: SendMessageViewModel<T>
    @EnvironmentObject var homeViewModel: HomeViewModel
    @EnvironmentObject var currentUser: CurrentUserService
         
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text(viewModel.captureCandidate.typeDescription + "s")) {
                    MessageListView(messages: currentUser.messagesToUser)
                }

                Section(header: Text(viewModel.captureCandidate.typeDescription + "s Sent")) {
                    MessageListView(messages: currentUser.messagesFromUser)
                }
                Section (header: Text("New " + viewModel.captureCandidate.typeDescription)){
                    TextField("Title", text: $viewModel.captureCandidate.title)
                    TextEditor(text: $viewModel.captureCandidate.content)
                        .multilineTextAlignment(.leading)
                }
                Button(action: viewModel.submit) {
                    if viewModel.isWorking {
                        ProgressView()
                    } else {
                        Text("Create " + viewModel.captureCandidate.typeDescription)
                    }
                }
                .frame(maxWidth: .infinity)
                .foregroundColor(.white)
                .listRowBackground(Color.accentColor)
                .padding()
            }
            .onSubmit(viewModel.submit)
            .onChange(of: viewModel.isWorking) {
                guard !viewModel.isWorking, viewModel.error == nil else { return }
            }
        }// NavigationStack
        .disabled(viewModel.isWorking)
        .dynamicTypeSize(...ViewConfiguration.dynamicSizeMax)
        .environment(\.font, Font.body)
        .padding()
    }
}


#if DEBUG
#Preview ("test messages") {
    MyMessagesView(viewModel: HomeViewModelTestData.shared.makeCreatePrivateMessageViewModel())
        .environmentObject(HomeViewModelTestData.shared)
        .environmentObject(CurrentUserTestData.sharedSignedIn)
}

#Preview ("test comments") {
    MyMessagesView(viewModel: HomeViewModelTestData.shared.makeCreatePublicCommentViewModel())
        .environmentObject(HomeViewModelTestData.shared)
        .environmentObject(CurrentUserTestData.sharedSignedIn)
}

#Preview ("live messages") {
    MyMessagesView(viewModel: HomeViewModelPreview.shared.makeCreatePrivateMessageViewModel())
        .environmentObject(HomeViewModelPreview.shared)
        .environmentObject(CurrentUser.shared)
}

#Preview ("live comments") {
    MyMessagesView(viewModel: HomeViewModelPreview.shared.makeCreatePublicCommentViewModel())
        .environmentObject(HomeViewModelPreview.shared)
        .environmentObject(CurrentUser.shared)
}
#endif
