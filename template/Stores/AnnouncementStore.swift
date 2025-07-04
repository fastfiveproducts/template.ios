//
//  AnnoucementStore.swift
//
//  Created by Pete Maiser, January 2025 through May 2025
//      made availble here:
//      https://github.com/fastfiveproducts/template.ios
//      per terms of the MIT License
//      changes should be rare; it is recommended changes are applied to the template
//      and the entire file compared-and-then-replaced here if/as appropriate
//


import Foundation

final class AnnouncementStore: ListableStore<Announcement> {
    
    // initiate this store as a Swift Singleton
    // this is also how to 'get' the singleton store
    static let shared = AnnouncementStore()
    
    // override ListableStore func below to set how to fetch data into the store
    override var fetchFromService: () async throws -> [Announcement] {
        {
            try await FirestoreConnector().fetchAnnouncements()
        }
    }
    
}

#if DEBUG
extension AnnouncementStore {
    static func testLoaded() -> AnnouncementStore {
        let store = AnnouncementStore()
        store.list = .loaded(Announcement.testObjects)
        return store
    }
}
#endif
