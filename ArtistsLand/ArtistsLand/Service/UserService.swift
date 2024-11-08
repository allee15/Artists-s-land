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
    var bag = Set<AnyCancellable>()
    
    private init() { }
    
    public lazy var userReactiveData = ReactiveData<UserState> { [weak self] in
        guard let self else {return nil}
        
        return Deferred {
            Future<UserState, Error> { promise in
                if self.isLoggedIn {
                    self.userApi.getUser()
                        .map { UserState.loggedIn($0) }
                        .catch { _ in Just(UserState.anonymous) }
                        .eraseToAnyPublisher()
                        .sink(receiveCompletion: { completion in
                            switch completion {
                            case .failure(let error):
                                promise(.failure(error))
                            case .finished:
                                break
                            }
                        }, receiveValue: { userState in
                            promise(.success(userState))
                        })
                        .store(in: &self.bag)
                } else {
                    promise(.success(UserState.anonymous))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    public var isLoggedIn: Bool {
        if let userState = userReactiveData.currentValue, case .loggedIn(_) = userState {
            return true
        }
        return false
    }
    
    func login(email: String, password: String) -> AnyPublisher<User, Error> {
        return userApi.login(email: email, password: password)
            .eraseToAnyPublisher()
    }
    
    func register(nickname: String, email: String, password: String, userType: String) -> AnyPublisher<User, Error> {
        return userApi.register(nickname: nickname, email: email, password: password, userType: userType)
            .eraseToAnyPublisher()
    }
    
    func logout() {
        self.userReactiveData.pushValue(value: .anonymous)
    }
    
    func deleteAccount() -> AnyPublisher<Bool, Error> {
        return userApi.deleteAccount()
            .eraseToAnyPublisher()
    }
    
    func changePassword(newPassword: String) -> AnyPublisher<Bool, Error> {
        return userApi.changePassword(newPassword: newPassword)
            .eraseToAnyPublisher()
    }
    
    func editAccount(nickname: String) -> AnyPublisher<Bool, Error> {
        return userApi.editAccount(nickname: nickname)
            .eraseToAnyPublisher()
    }
    
    func getBalance() -> AnyPublisher<Int64, Error> {
        return userApi.getBalance()
            .eraseToAnyPublisher()
    }
    
    func updateProfileImage(id: Int, avatar: Data? = nil, shouldDeleteAvatar: Bool? = nil) -> AnyPublisher<Bool, Error> {
        return userApi.updateProfileImage(id: id, avatar: avatar, shouldDeleteAvatar: shouldDeleteAvatar)
            .eraseToAnyPublisher()
    }
}
