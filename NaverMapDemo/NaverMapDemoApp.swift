//
//  NaverMapDemoApp.swift
//  NaverMapDemo
//
//  Created by 김지훈 on 2024/01/30.
//

import SwiftUI
import Firebase

@main
struct NaverMapDemoApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    
    var body: some Scene {
        WindowGroup {
            TestView1()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        // Firebase 실행확인 print
        print("Configured Firebase!")
        
        return true
    }
}
