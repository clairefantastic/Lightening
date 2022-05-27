//
//  AppDelegate.swift
//  Lightening
//
//  Created by claire on 2022/4/8.
//

import UIKit
import FirebaseFirestore
import Firebase
import IQKeyboardManagerSwift
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound,.badge, .carPlay], completionHandler: { (granted, error) in
                if granted {
                    print("允許")
                } else {
                    print("不允許")
                }
            })
        
        UNUserNotificationCenter.current().delegate = self
        
        FirebaseApp.configure()
        
        let settings = FirestoreSettings()
        settings.isPersistenceEnabled = false
        Firestore.firestore().settings = settings
        
        IQKeyboardManager.shared.enable = true
    
        if #available(iOS 15, *) {
            UINavigationBar.appearance().barTintColor = UIColor.lightBlue
            UINavigationBar.appearance().tintColor = UIColor.black
            UINavigationBar.appearance().isTranslucent = false
        } else {
            UINavigationBar.appearance().barTintColor = UIColor.lightBlue
            UINavigationBar.appearance().tintColor = UIColor.black
            UINavigationBar.appearance().isTranslucent = false
        }

        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        let deviceOrientation = UIInterfaceOrientationMask.portrait
        return deviceOrientation
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
            completionHandler([.badge, .sound, .alert])
        }
    
}
