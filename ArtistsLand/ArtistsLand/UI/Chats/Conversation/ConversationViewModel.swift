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
        chatService.getMessages(userId: chat.secondParticipantId)
            .receive(on: DispatchQueue.main)
            .sink { _ in
                
            } receiveValue: { [weak self] messages in
                guard let self else {return}
                self.messages.append(contentsOf: messages)
            }.store(in: &bag)
    }
    
    func sendMessage() {
        guard !message.isEmpty || image != nil else { return }
            
        let messageToSend = Message(senderId: user.id,
                                    receiverId: chat.secondParticipantId,
                                    message: message,
                                    fileUrl: nil,
                                    createdAt: "")
        let imageToSend = image?.jpegData(compressionQuality: 0.8)
        
        messages.append(messageToSend)
        message = ""
        image = nil
        
        chatService.sendMessage(message: messageToSend, imageData: imageToSend)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self else { return }
                if case .failure(_) = completion {
                    self.messages.removeAll { $0.createdAt == messageToSend.createdAt }
                    self.eventSubject.send(.failed)
                }
            } receiveValue: { [weak self] result in
                guard let self else {return}
                if let index = self.messages.firstIndex(where: { $0.message == messageToSend.message }) {
                    self.messages[index] = result
                }
                self.eventSubject.send(.imageSent)
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
