//
//  Chat.swift
//  ArtistsLand
//
//  Created by Alexia Aldea on 08.11.2024.
//

import Foundation

struct Chat {
    let conversationId: String
    let participant: Participant
    let lastMessage: String?
    let lastMessageTime: String?
}

struct Participant {
    let username: String
    let avatarUrl: String
}

struct Message {
    let senderId: String
    let receiverId: String
    let message: String
    let fileUrl: String?
    let createdAt: String
}
