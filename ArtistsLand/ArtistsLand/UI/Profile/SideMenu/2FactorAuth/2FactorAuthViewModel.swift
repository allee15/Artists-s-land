//
//  2FactorAuthViewModel.swift
//  ArtistsLand
//
//  Created by Alexia Aldea on 09.01.2025.
//

import Foundation
import Combine

enum FactorAuthCompletion {
    case completed
    case error
}

class FactorAuthViewModel: BaseViewModel {
    private var userService = UserService.shared
    
    @Published var userInfo: User
    @Published var isOn: Bool
    
    let eventSubject = PassthroughSubject<FactorAuthCompletion, Never>()
    
    init(userInfo: User) {
        self.userInfo = userInfo
        self.isOn = userInfo.isTwoFactorEnabled
    }
    
    func change2faStatus() {
        if isOn {
            self.enable2fa()
        } else {
            self.disable2fa()
        }
    }
    
    func enable2fa() {
        userService.enable2fa()
            .receive(on: DispatchQueue.main)
            .sink { _ in
                
            } receiveValue: { [weak self] result in
                guard let self else {return}
                if result {
                    self.userService.reloadUser()
                    self.eventSubject.send(.completed)
                } else {
                    self.eventSubject.send(.error)
                }
            }.store(in: &bag)
    }
    
    func disable2fa() {
        userService.disable2fa()
            .receive(on: DispatchQueue.main)
            .sink { _ in
                
            } receiveValue: { [weak self] result in
                guard let self else {return}
                if result {
                    self.userService.reloadUser()
                    self.eventSubject.send(.completed)
                } else {
                    self.eventSubject.send(.error)
                }
            }.store(in: &bag)
    }
}
