//
//  ListableStore.swift
//
//  Created by Pete Maiser, January 2025 through May 2025
//      made availble here:
//      https://github.com/fastfiveproducts/template.ios
//      per terms of the MIT License
//      changes should be rare; it is recommended changes are applied to the template
//      and the entire file compared-and-then-replaced here if/as appropriate
//

import Foundation


@MainActor
class ListableStore<T: Listable>: SignInOutObserver  {
        
    // primary data available from the store
    @Published var list: Loadable<[T]> = .none
        
    // enable generic access to the type
    let storeType: T.Type

    init(type: T.Type = T.self) {
        self.storeType = type
    }
    
    // enable generic access to typeDescription
    var storeTypeDescription: String { T.typeDescription }
    
    // set how to fetch data into the store
    var fetchFromService: (() async throws -> [T]) {
        debugprint("fetchFromService() called but no override present in \(storeTypeDescription) store subclass.")
        fatalError("Subclasses must override fetchFromService")
    }
    
    // fire-and-forget fetch
    func fetch() {
        Task {
            list = .loading
            do {
                let result = try await fetchFromService()
                debugprint("Fetched \(result.count) \(storeTypeDescription)s")
                list = .loaded(result)
                if result.isEmpty && storeType.usePlaceholder {
                    list = .loaded([storeType.placeholder])
                    debugprint("\(storeTypeDescription) placeholder used; now we have \(list.count) \(storeTypeDescription)s")
                }
            } catch {
                list = .error(error)
                debugprint("Error fetching \(storeTypeDescription)s: \(error)")
            }
        }
    }
    
    // async/await fetch with a callback return
    func fetchAndReturn() async -> Loadable<[T]> {
        list = .loading
        do {
            let result = try await fetchFromService()
            debugprint("Fetched \(result.count) \(storeTypeDescription)s")
            list = .loaded(result)
            if result.isEmpty && storeType.usePlaceholder {
                list = .loaded([storeType.placeholder])
                debugprint("\(storeTypeDescription) placeholder used; now we have \(list.count) \(storeTypeDescription)s")
            }
            return list
        } catch {
            debugprint("Error fetching \(storeTypeDescription)s: \(error)")
            list = .error(error)
            return list
        }
    }
    
}

#if DEBUG
extension ListableStore {
    static func testLoaded(with objects: [T]) -> ListableStore<T> {
        let store = ListableStore<T>()
        store.list = .loaded(objects)
        return store
    }

    static func testEmpty() -> ListableStore<T> {
        let store = ListableStore<T>()
        store.list = .loaded([])
        return store
    }

    static func testLoading() -> ListableStore<T> {
        let store = ListableStore<T>()
        store.list = .loading
        return store
    }

    static func testError(_ error: Error = NSError(domain: "Preview", code: 1, userInfo: nil)) -> ListableStore<T> {
        let store = ListableStore<T>()
        store.list = .error(error)
        return store
    }
}
#endif
