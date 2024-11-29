//
//  ChatService.swift
//  ArtistsLand
//
//  Created by Alexia Aldea on 08.11.2024.
//

import Foundation
import Combine

class ChatService {
    static let shared = ChatService()
    private let chatApi = ChatApi()
    var bag = Set<AnyCancellable>()
    
    private init() { }
    
    func getChats() -> AnyPublisher<[Chat], Error> {
        return chatApi.getChats()
            .eraseToAnyPublisher()
    }
    
    func sendMessage(message: Message, imageData: Data? = nil) -> AnyPublisher<Bool, Error> {
        return chatApi.sendMessage(message: message, imageData: imageData)
            .eraseToAnyPublisher()
    }
    
    func deleteChat(conversationId: String) -> AnyPublisher<Bool, Error> {
        return chatApi.deleteChat(conversationId: conversationId)
            .eraseToAnyPublisher()
    }
    
    func getMessages(userId: String) -> AnyPublisher<[Message], Error> {
        return chatApi.getMessages(userId: userId)
            .eraseToAnyPublisher()
    }
}
