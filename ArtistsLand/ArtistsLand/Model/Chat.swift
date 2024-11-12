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
    var artistAvatarUrl: String
}

let chatsMocked: [Chat] = [
    Chat(name: "Alexia", artistAvatarUrl: "https://recorder.ro/wp-content/uploads/2024/10/IMG_1181-1920x1081.jpg"),
    Chat(name: "Allee", artistAvatarUrl: "https://recorder.ro/wp-content/uploads/2024/10/IMG_1181-1920x1081.jpg")
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
    Message(date: Date(), message: "Buna", email: "alexia.elena.aldea@gmail.com", name: "Eu"),
    Message(date: Date(), message: "Hola", email: "tu@gmail.com", name: "Tu"),
    Message(date: Date(), message: "Hello", email: "el@gmail.com", name: "El")
]
