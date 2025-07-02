//
//  FormCaptureViewModel.swift
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


@MainActor
class FormCaptureViewModel<T: Listable>: ObservableObject {
    @Published var fields: [Capturable]

    let title: String
    private let makeCaptured: ([Capturable]) -> T

    init(title: String, fields: [Capturable], makeCaptured: @escaping ([Capturable]) -> T) {
        self.title = title
        self.fields = fields
        self.makeCaptured = makeCaptured
    }

    var isValid: Bool {
        fields.allSatisfy { $0.isValid }
    }

    func toCaptured() -> T {
        makeCaptured(fields)
    }
}
