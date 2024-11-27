//
//  ChatsViewModel.swift
//  ArtistsLand
//
//  Created by Alexia Aldea on 17.10.2024.
//

import Foundation

class ChatsViewModel: BaseViewModel {
    @Published var user: User?
    @Published var userChats: [Chat] = []
    
    var userService = UserService.shared
    var chatService = ChatService.shared
    
    override init() {
        super.init()
        self.getUserInfo()
        self.getChats()
    }
    
    private func getUserInfo() {
        userService.userReactiveData.getStateSubject()
            .sink(receiveCompletion: { _ in
                
            }, receiveValue: { [weak self] userState in
                guard let self = self else { return }
                self.user = userMocked
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
    
    private func getChats() {
        self.userChats = chatsMocked
        chatService.getChats()
    }
}
