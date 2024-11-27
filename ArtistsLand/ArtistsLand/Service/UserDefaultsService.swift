//
//  UserDefaultsService.swift
//  ArtistsLand
//
//  Created by Alexia Aldea on 18.10.2024.
//

import Foundation

enum UserDefaultsKeys {
    static let hasOnboardingCompleted = "onboardingIsOver"
    static let appTheme = "appTheme"
    static let notificationsSubscribed = "notificationsSubscribed"
    static let token = Key<String>(value: "token")
}

public struct Key<T> {
    let value: String
}

class UserDefaultsService {
    static let shared = UserDefaultsService()
    
    private let defaults: UserDefaults
    
    private init() {
        defaults = UserDefaults.standard
    }
    
    func setOnboarding(onboardingIsOver: Bool) {
        defaults.set(onboardingIsOver, forKey: UserDefaultsKeys.hasOnboardingCompleted)
    }
    
    func getOnboardingStatus() -> Bool {
        defaults.bool(forKey: UserDefaultsKeys.hasOnboardingCompleted)
    }
    
    func setValue<T>(key: Key<T>, value: Optional<T>) {
        defaults.set(value, forKey: key.value)
    }
    
    func getValue<T>(key: Key<T>) -> Optional<T> {
        return defaults.object(forKey: key.value) as? T
    }
    
    func setBooleanValue(key: Key<String>, value: Bool) {
        defaults.set(value, forKey: key.value)
    }
    
    func getBooleanValue(key: Key<String>) -> Bool {
        return defaults.bool(forKey: key.value)
    }
}
