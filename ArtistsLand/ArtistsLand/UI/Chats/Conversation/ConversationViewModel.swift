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
    @Published var user: User?
    @Published var message = ""
    @Published var messages: [Message] = []
    @Published var image: UIImage?
    
    var userService = UserService.shared
    
    override init() {
        super.init()
    }
    
    func sendMessage() {
        
    }
    
    func deleteChat() {
        
    }
}

struct Message: Codable, Identifiable {
    var id: String = UUID().uuidString
    var date: Date
    var message: String
    var email: String
    var name: String
    var imageUrl: String?
}
