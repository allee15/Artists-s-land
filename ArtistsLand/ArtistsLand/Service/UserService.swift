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
    let userDefaultsService = UserDefaultsService.shared
    
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
        if let token = authToken, !token.isEmpty {
            return true
        }
        return false
    }
    
    var authToken: String? {
        set {
            userDefaultsService.setValue(key: UserDefaultsKeys.token, value: newValue)
        }
        get {
            return userDefaultsService.getValue(key: UserDefaultsKeys.token)
        }
    }
    
    private init() {
        if !isLoggedIn {
            self.userReactiveData.pushValue(value: .anonymous)
        }
    }
    
    func login(email: String, password: String) -> AnyPublisher<UserResponse, Error> {
        return userApi.login(email: email, password: password)
            .handleEvents(receiveOutput: { [weak self] user in
                if !user.user.email.isEmpty {
                    self?.authToken = user.token
                    self?.userReactiveData.pushValue(value: .loggedIn(user.user))
                }
            })
            .eraseToAnyPublisher()
    }
    
    func register(nickname: String, email: String, password: String, userType: String) -> AnyPublisher<UserResponse, Error> {
        return userApi.register(nickname: nickname, email: email, password: password, userType: userType)
            .handleEvents(receiveOutput: { [weak self] user in
                if !user.user.email.isEmpty {
                    self?.authToken = user.token
                    self?.userReactiveData.pushValue(value: .loggedIn(user.user))
                }
            })
            .eraseToAnyPublisher()
    }
    
    func getUser() -> AnyPublisher<User, Error> {
        self.userApi.getUser()
            .handleEvents(receiveCompletion: { completion in
                if case .failure = completion {
                    self.userReactiveData.pushValue(value: .anonymous)
                }
            })
            .eraseToAnyPublisher()
    }
    
    func logout() -> AnyPublisher<Bool, Error> {
        self.userApi.logout()
            .handleEvents(receiveOutput: { _ in
                self.authToken = nil
                self.userReactiveData.pushValue(value: .anonymous)
            })
            .eraseToAnyPublisher()
    }
    
    func deleteAccount() -> AnyPublisher<Bool, Error> {
        return userApi.deleteAccount()
            .handleEvents(receiveOutput: { _ in
                self.authToken = nil
                self.userReactiveData.pushValue(value: .anonymous)
            })
            .eraseToAnyPublisher()
    }
    
    func changePassword(newPassword: String, currentPassword: String) -> AnyPublisher<Bool, Error> {
        return userApi.changePassword(newPassword: newPassword, currentPassword: currentPassword)
            .handleEvents(receiveOutput: { _ in
                self.userReactiveData.reload()
            })
            .eraseToAnyPublisher()
    }
    
    func editAccount(nickname: String? = nil, email: String? = nil) -> AnyPublisher<Bool, Error> {
        return userApi.editAccount(nickname: nickname, email: email)
            .handleEvents(receiveOutput: { _ in
                self.userReactiveData.reload()
            })
            .eraseToAnyPublisher()
    }
    
    func uploadProfilePicture(imageData: Data) -> AnyPublisher<Bool, Error> {
        return userApi.uploadProfilePicture(imageData: imageData)
            .handleEvents(receiveOutput: { _ in
                self.userReactiveData.reload()
            })
            .eraseToAnyPublisher()
    }
    
    func deleteProfilePicture() -> AnyPublisher<Bool, Error> {
        return userApi.deleteProfilePicture()
            .handleEvents(receiveOutput: { _ in
                self.userReactiveData.reload()
            })
            .eraseToAnyPublisher()
    }
    
    func getAllUsers() -> AnyPublisher<[User], Error> {
        userApi.getAllUsers()
            .eraseToAnyPublisher()
    }
    
    func getArtistInfo(artistId: Int64) {
        userApi.getArtistInfo(artistId: artistId)
    }
}
