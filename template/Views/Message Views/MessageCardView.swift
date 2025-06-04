//
//  MessageCardView.swift
//
//  Created by Pete Maiser, January 2025 through May 2025
//      made availble here:
//      https://github.com/fastfiveproducts/template.ios
//      per terms of the MIT License
//      changes should be rare; it is recommended changes are applied to the template
//      and the entire file compared-and-then-replaced here if/as appropriate
//


import SwiftUI

struct MessageCardView: View {
    let message: any Message
    var perspective: MessagePerspective?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {

            if perspective == .comment {
                HStack {
                    Text(message.timestamp.formatted(.dateTime))
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            
            if perspective == .inbox {
                HStack {
                    Text("From:")
                        .fontWeight(.semibold)
                    Text(message.from.displayName)
                        .lineLimit(1)
                        .truncationMode(.tail)
                    Spacer()
                    Text(message.timestamp.formatted(.dateTime))
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            
            if perspective == .sent {
                HStack {
                    if !message.to.displayName.isEmpty {
                        Text("To:")
                            .fontWeight(.semibold)
                        Text(message.to.displayName)
                            .lineLimit(1)
                            .truncationMode(.tail)
                        Spacer()
                    }
                    Text(message.timestamp.formatted(.dateTime))
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            
            if perspective == nil {
                HStack {
                    Text("From:")
                        .fontWeight(.semibold)
                    Text(message.from.displayName)
                        .lineLimit(1)
                        .truncationMode(.tail)
                    Spacer()
                    Text(message.timestamp.formatted(.dateTime))
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                HStack {
                    Text("To:")
                        .fontWeight(.semibold)
                    Text(message.to.displayName)
                        .lineLimit(1)
                        .truncationMode(.tail)
                }
            }
            
            if !message.title.isEmpty {
                Text(message.title)
                    .font(.headline)
                    .padding(.vertical, 2)
            }
            
            Text(message.content)
                .font(.body)
                .foregroundColor(.primary)
            
        }
        .padding(8)
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }
}


#if DEBUG
#Preview ("Section+List") {
    Form {
        Section(header: Text("All Comments")) {
            List {
                MessageCardView(message: PublicComment.testObject, perspective: .comment)
                MessageCardView(message: PublicComment.testObjectAnother, perspective: .comment)
            }
        }
        Section(header: Text("My Comments")) {
            List {
                MessageCardView(message: PublicComment.testObject, perspective: .sent)
            }
        }
        Section(header: Text("Comment no Perspective")) {
            List {
                MessageCardView(message: PublicComment.testObject)
            }
        }
        Section(header: Text("Inbox Messages")) {
            List {
                MessageCardView(message: PrivateMessage.testObject, perspective: .inbox)
            }
        }
        Section(header: Text("Sent")) {
            List {
                MessageCardView(message: PrivateMessage.testObject, perspective: .sent)
            }
        }
        Section(header: Text("Private Messages no filter")) {
            List {
                MessageCardView(message: PrivateMessage.testObject)
                MessageCardView(message: PrivateMessage.testObjectAnother)
            }
        }

    }
    .dynamicTypeSize(...ViewConfiguration.dynamicSizeMax)
    .environment(\.font, Font.body)
}
#endif
