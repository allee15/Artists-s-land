//
//  ConversationViewModel.swift
//  ArtistsLand
//
//  Created by Alexia Aldea on 07.11.2024.
//

import Foundation
import Combine
import UIKit

enum SendImageCompletion {
    case sent
    case failed
}

class ConversationViewModel: BaseViewModel {
    @Published var user: User
    @Published var message = ""
    @Published var messages: [Message] = []
    @Published var image: UIImage?
    @Published var chat: Chat
    
    var chatService = ChatService.shared
    let eventSubject = PassthroughSubject<SendImageCompletion, Never>()
    
    init(user: User, chat: Chat) {
        self.user = user
        self.chat = chat
        super.init()
        getMessages()
    }
    
    private func getMessages() {
        self.messages = messagesMocked
        chatService.getMessages()
    }
    
    func sendMessage() {
        chatService.sendMessage()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.eventSubject.send(.sent)
        }
    }
    
    func deleteChat() {
        chatService.deleteChat()
    }
}
