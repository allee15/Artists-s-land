//
//  Chat.swift
//  ArtistsLand
//
//  Created by Alexia Aldea on 08.11.2024.
//

import Foundation

struct Chat: Codable, Identifiable, Hashable {
    var id: String = UUID().uuidString
    var name: String
}

let chatsMocked: [Chat] = [
    Chat(name: "Alexia"),
    Chat(name: "Allee")
]

struct Message: Codable, Identifiable {
    var id: String = UUID().uuidString
    var date: Date
    var message: String
    var email: String
    var name: String
    var imageUrl: String?
}

let messagesMocked: [Message] = [
    Message(date: Date(), message: "Buna ziua", email: "alexia.elena.aldea@gmail.com", name: "Allee"),
    Message(date: Date(), message: "Hola", email: "tu@gmail.com", name: "Anonymous"),
    Message(date: Date(), message: "Hello", email: "tu@gmail.com", name: "Anonymous")
]
