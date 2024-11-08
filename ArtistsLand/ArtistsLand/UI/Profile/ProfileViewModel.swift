//
//  ProfileViewModel.swift
//  ArtistsLand
//
//  Created by Alexia Aldea on 17.10.2024.
//

import Foundation
import UIKit
import Combine

class ProfileViewModel: BaseViewModel {
    var userService = UserService.shared
    @Published var userInfo: User?
    @Published var profileImage: UIImage?
    @Published var isLoading: Bool = false
    let eventSubject = PassthroughSubject<EditAccountCompletion, Never>()
    
    override init() {
        super.init()
        getUserInfo()
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
    
    func updateProfileImage(id: Int, shouldDeleteAvatar: Bool? = nil) {
        userService.updateProfileImage(id: id, shouldDeleteAvatar: shouldDeleteAvatar)
            .sink(receiveCompletion: { _ in
                
            }, receiveValue: { [weak self] response in
                guard let self else {return}
                if response {
                    
                    self.eventSubject.send(.completed)
                } else {
                    self.eventSubject.send(.error)
                }
            }).store(in: &bag)
    }
}
