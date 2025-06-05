//
//  PostBubbleView.swift
//
//  Created by Pete Maiser, January 2025 through May 2025
//      made availble here:
//      https://github.com/fastfiveproducts/template.ios
//      per terms of the MIT License
//      changes should be rare; it is recommended changes are applied to the template
//      and the entire file compared-and-then-replaced here if/as appropriate
//


import SwiftUI

struct PostBubbleView: View {
    let message: any Post
    let isSent: Bool   // true = sent by current user
    var showFromUser: Bool = false
    var showToUser: Bool = false

    var bubbleColor: Color {
        isSent ? Color.accentColor : Color(.systemGray5)
    }

    var textColor: Color {
        isSent ? .white : .primary
    }

    var bubbleAlignment: Alignment {
        isSent ? .trailing : .leading
    }

    var body: some View {
        VStack(alignment: isSent ? .trailing : .leading, spacing: 4) {
            if showFromUser {
                HStack {
                    if isSent { Spacer() }
                    Text("From:")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(message.from.displayName)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    if !isSent { Spacer() }
                }
                .frame(maxWidth: .infinity)
            }

            if showToUser {
                HStack {
                    if isSent { Spacer() }
                    Text("To:")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(message.to.displayName)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    if !isSent { Spacer() }
                }
                .frame(maxWidth: .infinity)
            }

            VStack(alignment: .leading, spacing: 4) {
                if !message.title.isEmpty {
                    Text(message.title)
                        .font(.headline)
                        .foregroundColor(textColor)
                }

                Text(message.content)
                    .font(.body)
                    .foregroundColor(textColor)
            }
            .padding(10)
            .background(bubbleColor)
            .cornerRadius(12)
            .frame(maxWidth: .infinity, alignment: bubbleAlignment)

            HStack {
                if isSent { Spacer() }
                Text(message.timestamp.formatted(.dateTime))
                    .font(.caption2)
                    .foregroundColor(.gray)
                if !isSent { Spacer() }
            }
            .padding(.horizontal, 10)
        }
        .padding(.horizontal)
        .padding(.top, 4)
    }
}


#if DEBUG
#Preview {
    ScrollView {
        VStack(alignment: .leading, spacing: 16) {
            Section(header: Text("All Comments View")) {
                PostBubbleView(message: PublicComment.testObject, isSent: true, showFromUser: true)
                PostBubbleView(message: PublicComment.testObjectAnother, isSent: false, showFromUser: true)
            }

            Section(header: Text("My Comments View")) {
                PostBubbleView(message: PublicComment.testObject, isSent: true)
            }

            Section(header: Text("Inbox Messages View")) {
                PostBubbleView(message: PrivateMessage.testObjectAnother, isSent: false, showFromUser: true)
            }

            Section(header: Text("Sent View")) {
                PostBubbleView(message: PrivateMessage.testObject, isSent: true, showToUser: true)
            }

            Section(header: Text("Private Messages No Filter (Mixed)")) {
                PostBubbleView(message: PrivateMessage.testObject, isSent: true, showToUser: true)
                PostBubbleView(message: PrivateMessage.testObjectAnother, isSent: false, showFromUser: true)
            }
        }
        .padding()
    }
    .dynamicTypeSize(...ViewConfiguration.dynamicSizeMax)
    .environment(\.font, Font.body)
}
#endif
