//
//  EditAccountViewModel.swift
//  ArtistsLand
//
//  Created by Alexia Aldea on 06.11.2024.
//

import Foundation
import Combine

enum EditAccountCompletion {
    case completed
    case error
}

class EditAccountViewModel: BaseViewModel {
    let userInfo: User
    @Published var nickname: String
    @Published var email: String
    @Published var errorMessageName: String?
    let eventSubject = PassthroughSubject<EditAccountCompletion, Never>()
    
    var userService = UserService.shared
    
    init(userInfo: User) {
        self.userInfo = userInfo
        self.nickname = userInfo.nickname
        self.email = userInfo.email
        super.init()
        getUserInfo()
    }
    
    func getUserInfo() {
        
    }
    
    func editInfo() {
        if nickname.isEmpty {
            self.errorMessageName = "This field can't be empty."
        } else {
            //userService.editAccount()
            self.eventSubject.send(.completed)
        }
    }
}
