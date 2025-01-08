//
//  AppDelegate.swift
//  ArtistsLand
//
//  Created by Alexia Aldea on 15.10.2024.
//

import SwiftUI
import netfox
import Stripe

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        NFX.sharedInstance().start()
        StripeAPI.defaultPublishableKey = "pk_test_51NzPkBFsUJrHtrhWcN5jFB7GhTh92ru5Sh3UV7HQHCYaZFqvqdjzsvGkBf8iWPGDn9JspOFoFDtoJWxsLxaDw0HI00tiz22bSk"
        return true
    }
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
    }
}
