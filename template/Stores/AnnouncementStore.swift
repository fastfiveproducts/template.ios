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
    
    // initiate/get this store as a Swift Singleton
    static let shared = AnnouncementStore()
    
    // repository to from which to fetch data into the store
    private let cloudRepository: FirestoreDatabase = FirestoreDatabase()
    
    // fetching
    func fetchAnnouncements() async throws -> Loadable<[Announcement]> {
        #if DEBUG
        if isPreviewTestData {
            list = .loaded(Announcement.testAnnouncements)
            debugprint("loaded \(list.count) test Announcements")
            return list
        }
        #endif
        
        Task {
            list = .loading
            do {
                list = .loaded(try await cloudRepository.fetchAnnouncements())
                debugprint("fetched \(list.count) Announcements")
                if list.count == 0 {
                    list = .loaded([Announcement.placeholder])
                }
            }
            catch {
                debugprint("Error fetching Announcements: \(error)")
                list = .error(error)
            }
        }
        return list
    }
}
