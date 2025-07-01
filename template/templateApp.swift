//
//  templateApp.swift
//
//  Template created by Pete Maiser, July 2024 through May 2025
//      © Fast Five Products LLC, 2025
//      https://github.com/fastfiveproducts/template.ios
//      made available, and used here, per terms of the MIT License
//
//      Template v0.1.1
//


import SwiftUI
import SwiftData
import Firebase
import FirebaseAppCheck

@main
struct templateApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
        
    var body: some Scene {
        WindowGroup {
            HomeView(
                viewModel: HomeViewModel(),
                currentUserService: CurrentUserService.shared,      // will setup its own listener upon initialziation
                announcementStore: AnnouncementStore.shared,        // call fetch below as fire-and-forget
                publicCommentStore: PublicCommentStore.shared,      // will observe user sign-in and fetch at that point
                privateMessageStore: PrivateMessageStore.shared     // will observe user sign-in and fetch at that point
            )
                .task {AnnouncementStore.shared.fetch()}
        }
        .modelContainer(for: SampleLocalObject.self)
    }
}

class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        #if DEBUG
        let providerFactory = AppCheckDebugProviderFactory()
        AppCheck.setAppCheckProviderFactory(providerFactory)
        #endif
        
        FirebaseConfiguration.shared.setLoggerLevel(.error)         // Trying:  to reduce log 'spam'
        FirebaseApp.configure()                                     // Needed:  configure Firebase
        FirebaseConfiguration.shared.setLoggerLevel(.error)         // Trying:  to reduce log 'spam'
        
        return true
    }
}
