//
//  TextCaptureView.swift
//
//  Template created by Pete Maiser, July 2024 through May 2025
//      © Fast Five Products LLC, 2025
//      https://github.com/fastfiveproducts/template.ios
//      made available, and used here, per terms of the MIT License
//      changes should be rare; it is recommended changes are applied to the template
//      and the entire file compared-and-then-replaced here if/as appropriate
//
//      Template v0.1.2 (renamed from TextCaptureSectionView to TextCaptureView)
//


import Foundation
import SwiftUI

// ***** Sample Use - View *****
struct TextCaptureView: View {
    @ObservedObject var viewModel = TextCaptureViewModel()
    var showHeader: Bool = true
    
    @FocusState private var focusedFieldIndex: Int?
    private func nextField() {
        focusedFieldIndex = (focusedFieldIndex ?? -1) + 1
    }
    
    var body: some View {
        Section(header: showHeader ? Text(viewModel.title) : nil) {
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
        TextCaptureView()
    }
}
#endif
