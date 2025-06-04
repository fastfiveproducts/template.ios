//
//  MessageListView.swift
//
//  Created by Pete Maiser, January 2025 through May 2025
//      made availble here:
//      https://github.com/fastfiveproducts/template.ios
//      per terms of the MIT License
//      changes should be rare; it is recommended changes are applied to the template
//      and the entire file compared-and-then-replaced here if/as appropriate
//


import SwiftUI

struct MessageListView<T: Message>: View {
    @ObservedObject var store: ListableStore<T>
    
    var toUserId: String?
    var fromUserId: String?
    var messagePerspective: MessagePerspective?
    
    // Computed property to apply uid filtering
    private var filteredMessages: [T] {
        guard case let .loaded(messages) = store.list else {
            return []
        }
        return messages.filter { message in
            let toMatch = toUserId == nil || message.to.uid == toUserId
            let fromMatch = fromUserId == nil || message.from.uid == fromUserId
            return toMatch && fromMatch
        }
    }
    
    private var perspective: MessagePerspective? {
        if messagePerspective != nil { return messagePerspective }
        if toUserId != nil { return .inbox }
        if fromUserId != nil { return .sent }
        return nil
    }
    
    var body: some View {
        switch store.list {
        case .loading:
            HStack {
                Text("\(T.typeDisplayName)s: ")
                ProgressView()
            }
        case .loaded:
            if filteredMessages.isEmpty {
                Text("No matching \(T.typeDisplayName)s.")
            } else {
                List(filteredMessages) { message in
                    MessageCardView(message: message, perspective: perspective)
                }
            }
        case .error(let error):
            Text("Error on server loading \(T.typeDisplayName)s: \(error)")
        case .none:
            Text("\(T.typeDisplayName)s: none!")
        }
    }
}


#if DEBUG
#Preview {
    Form {
        Section(header: Text("Published Comments")) {
            MessageListView(store: PublicCommentStore.testLoaded(), messagePerspective: .comment)
        }
        Section(header: Text("Inbox Messages")) {
            MessageListView(store: PrivateMessageStore.testLoaded(), toUserId: UserAccount.testObject.userKey.uid)
        }
        Section(header: Text("Sent Messages")) {
            MessageListView(store: PrivateMessageStore.testLoaded(), fromUserId: UserAccount.testObject.userKey.uid)
        }
        Section(header: Text("All Messages")) {
            MessageListView(store: PrivateMessageStore.testLoaded())
        }
    }
    .dynamicTypeSize(...ViewConfiguration.dynamicSizeMax)
    .environment(\.font, Font.body)
}
#endif
