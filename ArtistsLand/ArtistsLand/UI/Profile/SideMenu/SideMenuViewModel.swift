//
//  SideMenuViewModel.swift
//  ArtistsLand
//
//  Created by Alexia Aldea on 06.11.2024.
//

import Foundation
import Combine

enum LogOutCompletion {
    case logout
    case delete
    case failure
}

class SideMenuViewModel: BaseViewModel {
    var userService = UserService.shared
    
    @Published var userInfo: User?
    @Published var isLoading: Bool = false
    
    var appVersion: String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
        return "\(version)"
    }
    let eventSubject = PassthroughSubject<LogOutCompletion, Never>()
    
    override init() {
        super.init()
        self.getUserInfo()
    }
    
    private func getUserInfo() {
        userService.userReactiveData.getStateSubject()
            .sink(receiveCompletion: { _ in
                
            }, receiveValue: { [weak self] userState in
                guard let self = self else { return }
                self.userInfo = userMocked
//                switch userState {
//                case .failure(_):
//                    self.isLoading = false
//                case .loading:
//                    self.isLoading = true
//                case .ready(let userState):
//                    self.isLoading = false
//                    switch userState {
//                    case .anonymous:
//                        self.userInfo = nil
//                    case .loggedIn(let user):
//                        self.userInfo = user
//                    }
//                }
            }).store(in: &bag)
    }
    
    func logOut() {
        userService.logout()
        self.eventSubject.send(.logout)
    }
    
    func deleteAccount() {
        self.eventSubject.send(.delete)
//        userService.deleteAccount()
//            .sink { _ in
//                
//            } receiveValue: { [weak self] response in
//                guard let self else {return}
//                if response {
//                    self.eventSubject.send(.delete)
//                } else {
//                    self.eventSubject.send(.failure)
//                }
//            }.store(in: &bag)
    }
}
