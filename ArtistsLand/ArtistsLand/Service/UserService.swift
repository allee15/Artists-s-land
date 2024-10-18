//
//  UserService.swift
//  ArtistsLand
//
//  Created by Alexia Aldea on 18.10.2024.
//

import Foundation
import Combine

class UserService {
    static let shared = UserService()
    private let userApi = UserApi()
    private init() { }
    
    func getUser() -> Future<User, Error> {
        return userApi.getUser()
    }
}

// for future
//in viewModel:
//enum UserState {
//    case loading
//    case failure(Error)
//    case value(User)
//}
//@Published var userState = UserState.loading
//func getUser() {
//    userState = .loading
//    userService.getUser()
//        .receive(on: DispatchQueue.main)
//        .sink { [weak self] completion in
//            guard let self else {return}
//            switch completion {
//            case .failure(let error):
//                self.userState = .failure(error)
//            case .finished:
//                break
//            }
//        } receiveValue: { [weak self] user in
//            guard let self else {return}
//            self.userState = .value(user)
//        } .store(in: &bag)
//}
//
//in view:
//switch viewModel.airportsState {
//case .failure( _):
//    
//case .loading:
//
//case .value(let airports):
