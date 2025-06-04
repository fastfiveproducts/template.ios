//
//  TextHelpers.swift
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

// The "TextConfiguration" struct contains custom Text Field parameters in a RangeReplaceableCollection
struct TextConfiguration {
    
    private(set) var name: String = ""
    private(set) var prompt: String = ""
    private(set) var autoCapitalization: TextInputAutocapitalization = TextInputAutocapitalization.words
    private(set) var required: Bool
    private(set) var checkRestrictedWordList: Bool
    private(set) var autoDisplay: Bool
    var capturedText: String = ""
    
    init(name: String,
         prompt: String,
         autoCapitalize: Bool = true,
         required: Bool = true,
         checkRestrictedWordList: Bool = true,
         autoDisplay: Bool = false)
    {
        self.name = name
        self.prompt = prompt
        if !autoCapitalize { self.autoCapitalization = TextInputAutocapitalization.never }
        self.required = required
        self.checkRestrictedWordList = checkRestrictedWordList
        self.autoDisplay = autoDisplay
    }
    
}

// Text Helper Views
struct TextEditorWithPlaceholder: View {
    @Binding var text: String
    let placeholder: String
    var minHeight: CGFloat = 100

    var body: some View {
        ZStack(alignment: .topLeading) {
            if text.isEmpty {
                Text(placeholder)
                    .foregroundColor(.gray)
                    .padding(.horizontal, 5)
                    .padding(.vertical, 8)
            }

            TextEditor(text: $text)
                .padding(4)
                .frame(minHeight: minHeight)
        }
    }
}
