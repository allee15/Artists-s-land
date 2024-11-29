//
//  ConversationViewModel.swift
//  ArtistsLand
//
//  Created by Alexia Aldea on 07.11.2024.
//

import Foundation
import Combine
import UIKit

enum ChatCompletion {
    case imageSent
    case failed
    case chatDeleted
}

class ConversationViewModel: BaseViewModel {
    var chatService = ChatService.shared
    
    @Published var user: User
    @Published var message = ""
    @Published var messages: [Message] = []
    @Published var image: UIImage?
    @Published var chat: Chat
    
    let eventSubject = PassthroughSubject<ChatCompletion, Never>()
    
    init(user: User, chat: Chat) {
        self.user = user
        self.chat = chat
        super.init()
        getMessages()
    }
    
    private func getMessages() {
        chatService.getMessages(userId: user.id)
            .receive(on: DispatchQueue.main)
            .sink { _ in
                
            } receiveValue: { [weak self] messages in
                guard let self else {return}
                self.messages.append(contentsOf: messages)
            }.store(in: &bag)
    }
    
    func sendMessage() {
        let messageToSend = Message(senderId: messages.first?.senderId ?? "",
                                    receiverId: messages.first?.receiverId ?? "",
                                    message: message,
                                    fileUrl: nil,
                                    createdAt: "")
        let imageToSend = image?.jpegData(compressionQuality: 0.8)
        
        chatService.sendMessage(message: messageToSend, imageData: imageToSend)
            .receive(on: DispatchQueue.main)
            .sink { _ in
                
            } receiveValue: { [weak self] result in
                guard let self else {return}
                if result {
                    self.messages.append(messageToSend)
                    self.eventSubject.send(.imageSent)
                }
            }.store(in: &bag)
    }
    
    func deleteChat() {
        chatService.deleteChat(conversationId: chat.conversationId)
            .receive(on: DispatchQueue.main)
            .sink { _ in
                
            } receiveValue: { [weak self] response in
                guard let self else {return}
                if response {
                    self.eventSubject.send(.chatDeleted)
                }
            }.store(in: &bag)
    }
}
