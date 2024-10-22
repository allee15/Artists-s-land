//
//  PushNotifications.swift
//  ArtistsLand
//
//  Created by Alexia Aldea on 22.10.2024.
//
import Foundation
import UserNotifications
import Combine
import UIKit

enum PushNotificationsStatus {
    case granted
    case notDetermined
    case denied
}

class PushNotificationsService {
    static let shared = PushNotificationsService()
    private let statusSubject = CurrentValueSubject<PushNotificationsStatus?, Never>(nil)
    private var cancellable: AnyCancellable?
    
    private init() {
        updateStatus()
        cancellable = NotificationCenter.default
            .publisher(for: UIApplication.willEnterForegroundNotification)
            .sink { [weak self] _ in
                self?.updateStatus()
            }
    }
    
    func loadCurrentStatus() -> AnyPublisher<PushNotificationsStatus, Never> {
        statusSubject
            .compactMap {$0}
            .first()
            .eraseToAnyPublisher()
    }
    
    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current()
            .requestAuthorization(
                options: UNAuthorizationOptions([.alert, .badge, .sound])) { [weak self] granted, error in
                    self?.updateStatus()
                    completion(granted)
                }
    }
    
    private func updateStatus() {
        UNUserNotificationCenter.current().getNotificationSettings { [weak self] settings in
            switch settings.authorizationStatus {
            case .denied:
                self?.statusSubject.send(.denied)
            case .notDetermined:
                self?.statusSubject.send(.notDetermined)
            case .authorized:
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
                self?.statusSubject.send(.granted)
            default:
                self?.statusSubject.send(.denied)
            }
        }
    }
    
    func goToSettings() {
        if let appSettings = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(appSettings) {
            UIApplication.shared.open(appSettings)
        }
    }
}
