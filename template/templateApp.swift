//
//  templateApp.swift
//  template
//
//  Created by Pete Maiser on 5/27/25.
//

import SwiftUI
import Firebase
import FirebaseAppCheck

@main
struct templateApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
        
    var body: some Scene {
        WindowGroup {
            HomeView(viewModel: HomeViewModel(currentUser: CurrentUserService.shared), currentUser: CurrentUserService.shared)
        }
    }
}

class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        return true
    }
}
