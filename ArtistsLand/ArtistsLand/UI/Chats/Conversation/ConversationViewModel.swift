//
//  ConversationViewModel.swift
//  ArtistsLand
//
//  Created by Alexia Aldea on 07.11.2024.
//

import Foundation
import Combine
import UIKit

class ConversationViewModel: BaseViewModel {
    @Published var user: User
    @Published var message = ""
    @Published var messages: [Message] = []
    @Published var image: UIImage?
    
    var chatService = ChatService.shared
    
    init(user: User) {
        self.user = user
        super.init()
        getMessages()
    }
    
    private func getMessages() {
        self.messages = messagesMocked
        chatService.getMessages()
    }
    
    func sendMessage() {
        chatService.sendMessage()
    }
    
    func deleteChat() {
        chatService.deleteChat()
    }
}
