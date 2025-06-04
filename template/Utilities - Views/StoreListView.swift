//
//  StoreListView.swift
//
//  Created by Pete Maiser, January 2025 through May 2025
//      made availble here:
//      https://github.com/fastfiveproducts/template.ios
//      per terms of the MIT License
//      changes should be rare; it is recommended changes are applied to the template
//      and the entire file compared-and-then-replaced here if/as appropriate
//

import SwiftUI

struct StoreListView<T: Listable>: View {
    @ObservedObject var store: ListableStore<T>
    
    var body: some View {
        switch store.list {
        case .loading:
            HStack {
                Text("\(T.typeDescription)s: ")
                ProgressView()
            }
        case let .loaded(objects):
            List(objects) { object in
                Text(object.objectDescription)
            }
        case .error(let error):
            Text("Cloud Error loading \(T.typeDescription)s: \(error)")
        case .none:
            Text("\(T.typeDescription)s: none!")
        }
    }
}

#if DEBUG
#Preview ("Loading, Loaded, Error") {
    Form {
        Section {
            StoreListView(store: ListableStore<Announcement>.testLoading())
            StoreListView(store: ListableStore<Announcement>.testLoaded(with: Announcement.testObjects))
            StoreListView(store: ListableStore<Announcement>.testError())
        }
    }
}
#Preview ("Empty") {
    Form {
        Section {
            StoreListView(store: ListableStore<Announcement>.testEmpty())
        }
    }
}
#endif
