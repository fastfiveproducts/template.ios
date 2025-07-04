//
//  RestrictedWordConnector.swift
//
//  Created by Pete Maiser in the year 2025 and made availble here:
//      https://github.com/fastfiveproducts/template.ios
//      per terms of the MIT License
//      changes should be rare; it is recommended changes are applied to the template
//      and the entire file compared-and-then-replaced here if/as appropriate
//


import Foundation
import FirebaseDataConnect
import DefaultConnector

struct RestrictedWordConnector {
    
    func fetchRestrictedWords() async throws -> [String] {
        return ["badword", "worseword"]   // TODO: fetch the data we need to do restricted text functionality
    }

}
