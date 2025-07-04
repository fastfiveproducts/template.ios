//
//  TextConfiguration.swift
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
    private(set) var checkRestrictedText: Bool
    private(set) var autoDisplay: Bool
    var capturedText: String = ""
    
    init(name: String,
         prompt: String,
         autoCapitalize: Bool = true,
         required: Bool = true,
         checkRestrictedText: Bool = true,
         autoDisplay: Bool = false)
    {
        self.name = name
        self.prompt = prompt
        if !autoCapitalize { self.autoCapitalization = TextInputAutocapitalization.never }
        self.required = required
        self.checkRestrictedText = checkRestrictedText
        self.autoDisplay = autoDisplay
    }
    
}
