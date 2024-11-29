//
//  JSONParsers.swift
//  ArtistsLand
//
//  Created by Alexia Aldea on 18.10.2024.
//

import Foundation
import SwiftyJSON

class JSONParsers {
    static func parseJsonUserResponse(json: JSON) -> UserResponse {
        return UserResponse(token: json["token"].stringValue,
                            user: parseJsonUser(json: json))
    }
    
    static func parseJsonUser(json: JSON) -> User {
        return User(
            id: json["_id"].stringValue,
            email: json["email"].stringValue,
            nickname: json["username"].stringValue,
            avatarUrl: json["profilePic"].stringValue,
            isArtist: json["accType"].stringValue == "artist" ? true : false,
            balance: json["balance"].doubleValue,
            level: json["level"].intValue,
            createdAt: Date(),
            posts: [] //todo fixme
        )
    }
    
    static func parseJsonChat(json: JSON) -> Chat {
        return Chat(conversationId: json["id"].stringValue,
                    participant: parseJsonParticipant(json: json),
                    lastMessage: json["lastMessage"].stringValue,
                    lastMessageTime: json["lastMessageTime"].stringValue)
    }
    
    static func parseJsonParticipant(json: JSON) -> Participant {
        return Participant(username: json["username"].stringValue,
                           avatarUrl: json["profilePic"].stringValue)
    }
    
    static func parseJsonMessage(json: JSON) -> Message {
        return Message(senderId: json["senderId"].stringValue,
                       receiverId: json["receiverId"].stringValue,
                       message: json["message"].stringValue,
                       fileUrl: json["fileUrl"].stringValue,
                       createdAt: json["createdAt"].stringValue)
    }
}
