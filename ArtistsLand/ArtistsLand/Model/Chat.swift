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
    Chat(name: "Alexia", artistAvatarUrl: "https://media.istockphoto.com/id/638756792/photo/beautiful-woman-posing-against-dark-background.jpg?s=612x612&w=0&k=20&c=AanwEr0pmrS-zhkVJEgAwxHKwnx14ywNh5dmzwbpyLk="),
    Chat(name: "Allee", artistAvatarUrl: "https://media.istockphoto.com/id/1300972574/photo/millennial-male-team-leader-organize-virtual-workshop-with-employees-online.jpg?s=612x612&w=0&k=20&c=uP9rKidKETywVil0dbvg_vAKyv2wjXMwWJDNPHzc_Ug=")
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
    Message(date: Date(), message: "Buna", email: "alexia.elena.aldea@gmail.com", name: "Allee"),
    Message(date: Date(), message: "Hola", email: "ana@gmail.com", name: "Ana"),
    Message(date: Date(), message: "Hello", email: "michael@gmail.com", name: "Michael")
]
