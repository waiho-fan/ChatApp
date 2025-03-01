//
//  ChatAppsApp.swift
//  ChatApps
//
//  Created by Gary on 1/3/2025.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        return true
    }
}

@main
struct ChatAppsApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
