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
    @Published var userInfo: User
    @Published var nickname: String
    @Published var email: String
    @Published var errorMessageName: String?
    @Published var isLoading: Bool = false
    let eventSubject = PassthroughSubject<EditAccountCompletion, Never>()
    
    var userService = UserService.shared
    
    init(userInfo: User) {
        self.userInfo = userInfo
        self.nickname = userInfo.nickname
        self.email = userInfo.email
    }
    
    func editInfo() {
        if nickname.isEmpty {
            self.errorMessageName = "This field can't be empty."
        } else {
            self.eventSubject.send(.completed)
//            userService.editAccount(nickname: nickname)
//                .sink { _ in
//                    
//                } receiveValue: { [weak self] response in
//                    guard let self else {return}
//                    if response {
//                        self.eventSubject.send(.completed)
//                    } else {
//                        self.eventSubject.send(.error)
//                    }
//                }.store(in: &bag)
        }
    }
}
