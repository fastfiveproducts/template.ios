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

struct MessageListView: View {
    @State var messages: Loadable<[PrivateMessage]>
    
    var body: some View {
        switch messages {
        case .loading:
            HStack {
                Text("Messages: ")
                ProgressView()
            }
        case .error(let error):
            Text("Error on server loading Messages: \(error)")
        case .empty:
            Text("None!")
        case let .loaded(things):
            List(things) { thing in
                VStack {
                    HStack{
                        Text("To: " + thing.to.displayName)
                        Spacer()
                    }
                    HStack{
                        Text("From: " + thing.from.displayName)
                        Spacer()
                    }
                    HStack{
                        Text(thing.content)
                        Spacer()
                    }
                }
            }
        case .none:
            Text("Messages: none!")
        }
    }
}


#if DEBUG
#Preview {
    Form {
        Section {
            MessageListView(
                messages: CurrentUserTestData.sharedSignedIn.messagesToUser
            )
        }
    }
}
#endif
