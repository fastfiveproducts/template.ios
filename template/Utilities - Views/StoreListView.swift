//
//  StoreListView.swift
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

struct StoreListView<T: Listable>: View {
    @ObservedObject var store: ListableStore<T>
    var showDividers: Bool = true
    
    var body: some View {
        switch store.list {
        case .loading:
            HStack {
                Text("\(T.typeDescription)s: ")
                ProgressView()
            }
        case let .loaded(objects):
            ForEach(objects.indices, id: \.self) { index in
                VStack(alignment: .leading, spacing: 4) {
                    let object = objects[index]
                    Text(object.objectDescription)
                    if showDividers && index < objects.count - 1 {
                        Divider()
                            .padding(.top, 6)
                    }
                }
            }
        case .error(let error):
            Text("Cloud Error loading \(T.typeDescription)s: \(error)")
        case .none:
            Text("\(T.typeDescription)s: nothing here")
        }
    }
}

#if DEBUG
#Preview ("Form: Loaded") {
    Form {
        Section(header: Text("Announcements")) {
            StoreListView(store: ListableStore<Announcement>.testLoaded(with: Announcement.testObjects), showDividers: false)
        }
    }
    .dynamicTypeSize(...ViewConfiguration.dynamicSizeMax)
    .environment(\.font, Font.body)
}
#Preview ("VStackBox: Loaded") {
    VStackBox(title: "Announcements") {
        StoreListView(store: ListableStore<Announcement>.testLoaded(with: Announcement.testObjects))
    }
    .dynamicTypeSize(...ViewConfiguration.dynamicSizeMax)
    .environment(\.font, Font.body)
}
#Preview ("Form: Loading, Error") {
    Form {
        Section {
            StoreListView(store: ListableStore<Announcement>.testLoading(), showDividers: false)
            StoreListView(store: ListableStore<Announcement>.testError(), showDividers: false)
        }
    }
    .dynamicTypeSize(...ViewConfiguration.dynamicSizeMax)
    .environment(\.font, Font.body)
}
#Preview ("Empty") {
    Form {
        Section {
            StoreListView(store: ListableStore<Announcement>.testEmpty(), showDividers: false)
        }
    }
    .dynamicTypeSize(...ViewConfiguration.dynamicSizeMax)
    .environment(\.font, Font.body)
}
#endif
