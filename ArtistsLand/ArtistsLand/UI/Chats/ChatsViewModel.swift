//
//  ChatsViewModel.swift
//  ArtistsLand
//
//  Created by Alexia Aldea on 17.10.2024.
//

import Foundation
import Combine

enum ChatsState {
    case loading
    case failure(Error)
    case value([Chat])
}


class ChatsViewModel: BaseViewModel {
    var userService = UserService.shared
    var chatService = ChatService.shared
    
    @Published var user: User?
    @Published var isLoading: Bool = false
    
    @Published var chatsState = ChatsState.loading
    
    override init() {
        super.init()
        self.getUserInfo()
        self.getChats()
    }
    
    private func getUserInfo() {
        userService.userReactiveData.getStateSubject()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in
                
            }, receiveValue: { [weak self] userState in
                guard let self = self else { return }
                switch userState {
                case .failure(_):
                    self.isLoading = false
                case .loading:
                    self.isLoading = true
                case .ready(let userState):
                    self.isLoading = false
                    switch userState {
                    case .anonymous:
                        self.user = nil
                    case .loggedIn(let user):
                        self.user = user
                    }
                }
            }).store(in: &bag)
    }
    
    func getChats() {
        chatService.getChats()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self else { return }
                switch completion {
                case .failure(let error):
                    self.chatsState = .failure(error)
                case .finished:
                    break
                }
            } receiveValue: { [weak self] chats in
                guard let self else {return}
                self.chatsState = .value(chats)
            }.store(in: &bag)
    }
}
