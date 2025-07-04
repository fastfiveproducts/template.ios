//
//  CustomLabeledContentStyle.swift
//
//  Template by Pete Maiser, July 2024 through May 2025
//      made availble here:
//      https://github.com/fastfiveproducts/template.ios
//      per terms of the MIT License
//
//  This particular implementation is for:
//      APP_NAME
//      DATE
//      YOUR_NAME
//


import SwiftUI

// custom Text Field LabeledContentStyle, 'Top Labeled':

struct TopLabeledContentStyle: LabeledContentStyle {
    func makeBody(configuration: Configuration) -> some View {
        VStack(alignment: .leading) {
            configuration.label
                .font(.caption)
            configuration.content
        }
    }
}

#if DEBUG
fileprivate struct TopLabelLabeledContentStylePreview: View {
    var config: TextConfiguration
    @FocusState private var focusedFieldIndex: Int?
    var body: some View {
        LabeledContent {
            TextField(config.prompt, text:.constant(""))
                .textInputAutocapitalization(config.autoCapitalization)
                .disableAutocorrection(true)
                .onSubmit {}
                .focused($focusedFieldIndex, equals: 0)
        } label: { Text(config.name) }
            .labeledContentStyle(TopLabeledContentStyle())
    }
}


#Preview ("TopLabelLabeledContentStyle") {
    Form {
        Section {
            TopLabelLabeledContentStylePreview(config: TextConfiguration(name: "Your Name", prompt: "required:  Name or Intitials"))
            TopLabelLabeledContentStylePreview(config: TextConfiguration(name: "More Stuff", prompt: "stuff we want to know"))
        }
    }
    .dynamicTypeSize(...ViewConfiguration.dynamicSizeMax)
}
#endif
