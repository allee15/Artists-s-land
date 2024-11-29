//
//  Chat.swift
//  ArtistsLand
//
//  Created by Alexia Aldea on 08.11.2024.
//

import Foundation

struct Chat: Decodable {
    let conversationId: String
    let participant: Participant
    let lastMessage: String?
    let lastMessageTime: String?
}

struct Participant: Decodable {
    let username: String
    let avatarUrl: String
}

struct Message: Codable, Identifiable {
    var id: String = UUID().uuidString
    var date: Date
    var message: String
    var email: String
    var name: String
    var imageUrl: String?
}

let messagesMocked: [Message] = [
    Message(date: Date(), message: "Buna", email: "alexia.elena.aldea@gmail.com", name: "Allee"),
    Message(date: Date(), message: "Hola", email: "ana@gmail.com", name: "Ana"),
    Message(date: Date(), message: "Hello", email: "michael@gmail.com", name: "Michael")
]
