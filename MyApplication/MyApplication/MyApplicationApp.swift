//
//  MyApplicationApp.swift
//  MyApplication
//
//  Created by Eitan Tuchin on 12/19/24.
//

import SwiftUI
import SwiftData
import FirebaseCore
import FirebaseAuth
import GoogleSignIn

@main
struct MyApplicationApp: App {
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(MyApplication.self) var delegate
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    var body: some Scene {
        WindowGroup {
            StartScreen()
        }
        .modelContainer(sharedModelContainer)
    }
}

class MyApplication: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        // Check if there's already a signed-in user
        if let currentUser = Auth.auth().currentUser {
            print("User is already signed in: \(currentUser.email ?? "Unknown email")")
        }
        else {
            print("No user is signed in.")
        }
        return true
    }
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }
}

