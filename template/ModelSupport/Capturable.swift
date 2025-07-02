//
//  Capturable.swift
//
//  Template created by Pete Maiser, July 2024 through July 2025
//      © Fast Five Products LLC, 2025
//      https://github.com/fastfiveproducts/template.ios
//      made available, and used here, per terms of the MIT License
//      changes should be rare; it is recommended changes are applied to the template
//      and the entire file compared-and-then-replaced here if/as appropriate
//
//      Template v0.1.2 (renamed and split-out from TextCaptureSectionView)
//


import Foundation

protocol Capturable {
    var labelText: String { get }
    var promptText: String { get }
    var text: String { get set }
    
    var required: Bool { get }
    var autoCapitalize: Bool { get }
    var checkRestrictedWordList: Bool { get }
    
    var isValid: Bool { get }
}

extension Capturable {
    var required: Bool { true }                     // override in struct if appropriate
    var autoCapitalize: Bool { true }               // override in struct if appropriate
    var checkRestrictedWordList: Bool { true }      // override in struct if appropriate

    var isValid: Bool {
        !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || !required
    }
}
