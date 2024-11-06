//
//  NotificationsSettingsViewModel.swift
//  ArtistsLand
//
//  Created by Alexia Aldea on 22.10.2024.
//

import Foundation
import Combine

enum NotificationSettingsState {
    case loading
    case failure(Error)
    case value
}

enum NotificationSettingsEvent {
    case notificationsDenied
    case completed
}

class NotificationsSettingsViewModel: BaseViewModel {
    var pushNotificationsService = PushNotificationsService.shared
    var notificationsSettingsService = NotificationsSettingsService.shared
    
    @Published var pushNotificationsStatus: PushNotificationsStatus?
    @Published var isOn: Bool
    @Published var notificationSettingsEvent = PassthroughSubject<NotificationSettingsEvent, Never>()
    @Published var notificationSettingsState = NotificationSettingsState.loading
    
    override init() {
        self.isOn = self.notificationsSettingsService.getIsTopicSubscribed()
        
        super.init()
        self.loadCurrentStatus(isLoadingFirstTime: true)
    }
    
    func goToSettings() {
        pushNotificationsService.goToSettings()
    }
    
    func loadCurrentStatus(isLoadingFirstTime: Bool = false) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.pushNotificationsService.loadCurrentStatus()
                .receive(on: DispatchQueue.main)
                .sink { [weak self] completion in
                    guard let self else {return}
                    switch completion {
                    case .failure(let error):
                        self.notificationSettingsState = .failure(error)
                    case .finished:
                        break
                    }
                } receiveValue: { [weak self] status in
                    guard let self else {return}
                    self.pushNotificationsStatus = status
                    if !isLoadingFirstTime {
                        if status == .notDetermined {
                            self.onAllowPushNotificationPressed(status: status)
                        }
                    }
                    self.notificationSettingsState = .value
                }.store(in: &self.bag)
        }
    }
    
    func requestNotificationAuthorization() {
        self.pushNotificationsService.requestAuthorization(completion: { granted in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                if granted {
                    self.pushNotificationsStatus = .granted
                    self.subscribeToTopic()
                } else {
                    self.handleDeniedNotification()
                }
            }
        })
    }
    
    func onAllowPushNotificationPressed(status: PushNotificationsStatus) {
        switch status {
        case .granted:
            break
        case .notDetermined:
            self.requestNotificationAuthorization()
        case .denied:
            self.handleDeniedNotification()
        }
    }
    
    func handleDeniedNotification() {
        self.pushNotificationsStatus = .denied
    }
    
    func handleNotificationToggle() {
        if self.pushNotificationsStatus == .notDetermined {
            self.loadCurrentStatus()
        } else if self.pushNotificationsStatus == .denied {
            self.notificationSettingsEvent.send(.notificationsDenied)
            self.handleDeniedNotification()
        } else if !isOn {
            self.subscribeToTopic()
        } else {
            self.unsubscribeFromTopic()
        }
    }
    
    func subscribeToTopic() {
        notificationsSettingsService.subscribeToTopic()
        self.notificationSettingsEvent.send(.completed)
    }
    
    func unsubscribeFromTopic() {
        notificationsSettingsService.unsubscribeFromTopic()
        self.notificationSettingsEvent.send(.completed)
    }
    
    func watchStatus() {
        self.pushNotificationsService.loadCurrentStatus()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
            } receiveValue: { [weak self] notificationStatus in
                guard let self else {return}
                switch notificationStatus {
                case .denied:
                    self.pushNotificationsStatus = .denied
                case .granted:
                    self.pushNotificationsStatus = .granted
                case .notDetermined:
                    self.pushNotificationsStatus = .notDetermined
                }
            }.store(in: &bag)
    }
}
