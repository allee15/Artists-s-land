//
//  Chat.swift
//  ArtistsLand
//
//  Created by Alexia Aldea on 08.11.2024.
//

import Foundation

struct Chat {
    let conversationId: String
    let lastMessage: String?
    let lastMessageTime: String?
    let secondParticipantId: String
    let secondParticipantName: String
    let secondParticipantAvatar: String?
}

struct Message {
    let senderId: String
    let receiverId: String
    let message: String
    let fileUrl: String?
    let createdAt: String
}
