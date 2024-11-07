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
    
    override init() {
        super.init()
    }
}

struct Chat: Codable, Identifiable, Hashable {
    var id: String = UUID().uuidString
    var name: String
}
