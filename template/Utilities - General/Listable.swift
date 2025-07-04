//
//  Listable.swift
//
//  Created by Pete Maiser, January 2025 through May 2025
//      made availble here:
//      https://github.com/fastfiveproducts/template.ios
//      per terms of the MIT License
//      changes should be rare; it is recommended changes are applied to the template
//      and the entire file compared-and-then-replaced here if/as appropriate
//


import Foundation

protocol Listable: Identifiable, Equatable, Codable, DebugPrintable {
    static var typeDescription: String { get }
    var objectDescription: String { get }
}

extension Listable {
    func dateString(from date: Date?) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        let string = date != nil ? dateFormatter.string(from: date!) : "unknown date"
        return string
    }
}

@MainActor
class ListableStore<T: Listable>: ObservableObject, DebugPrintable {
        
    // primary data available from the store
    @Published var list: Loadable<[T]> = .empty
}
