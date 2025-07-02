//
//  FormCapturable.swift
//
//  Template created by Pete Maiser, July 2024 through July 2025
//      © Fast Five Products LLC, 2025
//      https://github.com/fastfiveproducts/template.ios
//      made available, and used here, per terms of the MIT License
//      changes should be rare; it is recommended changes are applied to the template
//      and the entire file compared-and-then-replaced here if/as appropriate
//
//      Template v0.1.2
//


import Foundation

protocol FormCapturable {
    associatedtype CapturedType: Listable
    var title: String { get }
    var fieldList: [any Capturable] { get set }
}
