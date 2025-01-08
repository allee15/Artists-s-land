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
            level: json["level"].intValue
        )
    }
    
    static func parseJsonPosts(json: JSON) -> [Post] {
        return json.arrayValue.map { postJson in
            Post(
                id: postJson["_id"].stringValue,
                description: postJson["description"].stringValue,
                date: postJson["createdAt"].stringValue,
                artistName: postJson["artistId"]["username"].stringValue,
                artistId: postJson["artistId"]["_id"].stringValue,
                artistAvatarUrl: postJson["artistId"]["profilePic"].stringValue,
                nbOfLikes: postJson["likes"].arrayValue.count,
                postUrl: postJson["postUrl"].stringValue,
                comments: postJson["comments"].arrayValue.map { subJson in
                    parseJsonComment(json: subJson)
                }
            )
        }
    }
    
    static func parseJsonComment(json: JSON) -> Comment {
        return Comment(id: json["_id"].stringValue,
                       name: json["userId"]["username"].stringValue,
                       description: json["message"].stringValue)
    }
    
    static func parseJsonChat(json: JSON) -> Chat {
        return Chat(conversationId: json["conversationId"].stringValue,
                    lastMessage: json["lastMessage"].stringValue,
                    lastMessageTime: json["lastMessageTime"].stringValue,
                    secondParticipantId: json["secondParticipantId"].stringValue,
                    secondParticipantName: json["secondParticipantUsername"].stringValue,
                    secondParticipantAvatar: json["secondParticipantProfilePic"].stringValue == "" ? nil : json["secondParticipantProfilePic"].stringValue)
    }
    
    static func parseJsonMessage(json: JSON) -> Message {
        return Message(senderId: json["senderId"].stringValue,
                       receiverId: json["receiverId"].stringValue,
                       message: json["message"].stringValue,
                       fileUrl: json["fileUrl"].stringValue,
                       createdAt: json["createdAt"].stringValue.toFormattedDateString() ?? "")
    }
    
    static func parseJsonStripe(json: JSON) -> String {
        return json["clientSecret"].stringValue
    }
}
