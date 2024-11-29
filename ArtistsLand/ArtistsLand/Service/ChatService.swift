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
    
    func sendMessage() {
        chatApi.sendMessage()
    }
    
    func deleteChat() {
        chatApi.deleteChat()
    }
    
    func getMessages() {
        chatApi.getMessages()
    }
    
    func createChat(artistId: Int) {
        chatApi.createChat(artistId: artistId)
    }
}
