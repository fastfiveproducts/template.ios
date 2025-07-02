//
//  ListableFileStoreViewModel.swift
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


// TODO:  THIS MAY BE RENAMED

import Foundation
import SwiftUI

@MainActor
class ListableFileStoreViewModel<T: Listable>: ObservableObject {
    
    @Published var store: ListableFileStore<T>

    init(filename: String = "\(T.typeDescription).json") {
        self.store = ListableFileStore<T>(filename: filename)
        store.load()
    }

    // MARK: - Insert
    func insert(_ item: T) {
//        if item is Validatable, let validatable = item as? Validatable, !validatable.isValid {
//            return
//        }
        store.insert(item)
    }

    // MARK: - Update
    func update(_ item: T) {
        store.update(item)
    }

    // MARK: - Delete
    func delete(_ item: T) {
        store.delete(item)
    }

    // MARK: - Delete All
    func deleteAll() {
        store.deleteAll()
    }
}
