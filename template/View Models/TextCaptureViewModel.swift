//
//  TextCaptureViewModel.swift
//
//  Created by Pete Maiser on 6/20/25.
//      © Fast Five Products LLC, 2025
//      https://github.com/fastfiveproducts/template.ios
//      made available, and used here, per terms of the MIT License
//      changes should be rare; it is recommended changes are applied to the template
//      and the entire file compared-and-then-replaced here if/as appropriate
//
//      Template v0.1.2 (moved from another Template v0.1.1 file)
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
        TextCaptureConfiguration(name: "favorite color", prompt: "required: Favorite Color"),
        TextCaptureConfiguration(name: "dog name", prompt: "required: Your Dog's Name")
    ]
}
