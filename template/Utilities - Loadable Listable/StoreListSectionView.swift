//
//  StoreListSectionView.swift
//
//  Template created by Pete Maiser, July 2024 through May 2025
//      © Fast Five Products LLC, 2025
//      https://github.com/fastfiveproducts/template.ios
//      made available, and used here, per terms of the MIT License
//      changes should be rare; it is recommended changes are applied to the template
//      and the entire file compared-and-then-replaced here if/as appropriate
//
//      Template v0.1.1
//


import SwiftUI

struct StoreListSectionView<T: Listable>: View {
    @ObservedObject var store: ListableStore<T>
    
    var body: some View {
        // Hide section entirely if it's a loaded empty list
        if case let .loaded(objects) = store.list, objects.isEmpty {
            EmptyView()
        } else {
            Section(header: Text("\(T.typeDescription)s")) {
                StoreListView(store: store, showDividers: false)
            }
        }
    }
}


#if DEBUG
#Preview ("Loading, Loaded, Error") {
    Form {
        StoreListSectionView(store: ListableStore<Announcement>.testLoading())
        StoreListSectionView(store: ListableStore<Announcement>.testLoaded(with: Announcement.testObjects))
        StoreListSectionView(store: ListableStore<Announcement>.testError())
    }
    .dynamicTypeSize(...ViewConfiguration.dynamicSizeMax)
    .environment(\.font, Font.body)
}
#Preview ("Empty") {
    Form {
        StoreListSectionView(store: ListableStore<Announcement>.testEmpty())
    }
    .dynamicTypeSize(...ViewConfiguration.dynamicSizeMax)
    .environment(\.font, Font.body)
}
#endif
