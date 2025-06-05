//
//  TextCaptureSectionView.swift
//
//  Created by Pete Maiser, January 2025 through May 2025
//      made availble here:
//      https://github.com/fastfiveproducts/template.ios
//      per terms of the MIT License
//      changes should be rare; it is recommended changes are applied to the template
//      and the entire file compared-and-then-replaced here if/as appropriate
//

import Foundation
import SwiftUI


// ***** Config Struct for Mass Text Capture *****
struct TextCaptureConfiguration {
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
         autoDisplay: Bool = true)
    {
        self.name = name
        self.prompt = prompt
        if !autoCapitalize { self.autoCapitalization = TextInputAutocapitalization.never }
        self.required = required
        self.checkRestrictedWordList = checkRestrictedWordList
        self.autoDisplay = autoDisplay
    }
}


// ***** Sample Use - View Model *****
@MainActor
class TextCaptureViewModel: ObservableObject
{
    var title: String = "Text Capture Sample"
    var textFieldList: [TextCaptureConfiguration] = [
        TextCaptureConfiguration(name: "sign-in email address", prompt: "required: Email Address", autoCapitalize: false, autoDisplay: false),
        TextCaptureConfiguration(name: "password hint", prompt: "Password Hint", autoCapitalize: false, required: false, checkRestrictedWordList: false),
        TextCaptureConfiguration(name: "display name", prompt: "required: Display Name"),
        TextCaptureConfiguration(name: "favorite color", prompt: "required: Favorite Color"),
        TextCaptureConfiguration(name: "dog name", prompt: "required: Your Dog's Name"),
        TextCaptureConfiguration(name: "more stuff", prompt: "more stuff we want to know")
    ]
}


// ***** Sample Use - View *****
struct TextCaptureSectionView: View {
    @ObservedObject var viewModel = TextCaptureViewModel()
    
    @FocusState private var focusedFieldIndex: Int?
    private func nextField() {
        focusedFieldIndex = (focusedFieldIndex ?? -1) + 1
    }
    
    var body: some View {
        Section(header: Text(viewModel.title)) {
            ForEach(viewModel.textFieldList.indices, id: \.self) { i in
                if viewModel.textFieldList[i].autoDisplay {
                    displayLabeledTextField(atIndex: i)
                }
            }
        }
    }
        
    private func displayLabeledTextField(atIndex i: Int) -> some View {
        LabeledContent {
            TextField(viewModel.textFieldList[i].prompt, text: $viewModel.textFieldList[i].capturedText)
                .textInputAutocapitalization(viewModel.textFieldList[i].autoCapitalization)
                .disableAutocorrection(true)
                .focused($focusedFieldIndex, equals: i)
                .onTapGesture { focusedFieldIndex = i }
                .onSubmit {nextField()}
        } label: { Text(viewModel.textFieldList[i].name) }
            .labeledContentStyle(TopLabeledContentStyle())
    }
}


// ***** Sample Use *****
#if DEBUG
#Preview {
    Form {
        TextCaptureSectionView()
    }
}
#endif
