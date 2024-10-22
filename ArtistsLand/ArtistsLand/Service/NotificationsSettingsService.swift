//
//  NotificationsSettingsService.swift
//  ArtistsLand
//
//  Created by Alexia Aldea on 22.10.2024.
//

import Foundation
import Combine
import FirebaseMessaging

class NotificationsSettingsService {
    static let shared = NotificationsSettingsService()
    var userDefaultsService = UserDefaultsService.shared
    
    private init() {}
    
    func subscribeToTopic() {
        Messaging.messaging().subscribe(toTopic: "notificationsSubscribed") { error in
            let keyTransformed: Key<Bool> = Key(value: UserDefaultsKeys.notificationsSubscribed)
            
            if let error = error {
                self.userDefaultsService.setValue(key: keyTransformed, value: false)
                print("Error subscribing to topic")
            } else {
                self.userDefaultsService.setValue(key: keyTransformed, value: true)
                print("Subscribed to topic")
            }
        }
    }
    
    func unsubscribeFromTopic() {
        Messaging.messaging().unsubscribe(fromTopic: "notificationsSubscribed") { error in
            let keyTransformed: Key<String> = Key(value: UserDefaultsKeys.notificationsSubscribed)
            
            if let error = error {
                print("Error unsubscribing from topic")
            } else {
                self.userDefaultsService.setBooleanValue(key: keyTransformed, value: false)
                print("Unsubscribed from topic")
            }
        }
    }
    
    func getIsTopicSubscribed() -> Bool {
        return userDefaultsService.getBooleanValue(key: .init(value: UserDefaultsKeys.notificationsSubscribed))
    }
}
