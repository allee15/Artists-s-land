//
//  ChatApi.swift
//  ArtistsLand
//
//  Created by Alexia Aldea on 08.11.2024.
//

import Foundation
import Combine
import SwiftyJSON

class ChatApi {
    func getChats() -> AnyPublisher<[Chat], Error> {
        Future { promise in
            let urlComponents = URLComponents(string: "\(DefaultAPIEnvironment.basePath)/api/messages/get-conversations")
            
            var urlRequest = URLRequest(url: (urlComponents?.url)!)
            
            urlRequest.httpMethod = "GET"
            
            if let token = UserDefaultsService.shared.getValue(key: UserDefaultsKeys.token) {
                urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            }
            
            let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    do {
                        var arrayToReturn = [Chat]()
                        let json = try JSON(data: data!)
                        if json["message"].stringValue != "No conversations found" {
                            for (_, item) in json {
                                
                                let chat = JSONParsers.parseJsonChat(json: item)
                                arrayToReturn.append(chat)
                            }
                        }
                        promise(.success(arrayToReturn))
                    } catch {
                        promise(.failure(error))
                    }
                }
            }
            dataTask.resume()
        }.eraseToAnyPublisher()
    }
    
    func sendMessage(message: Message, imageData: Data?) -> AnyPublisher<Bool, Error> {
        Future { promise in
            let url = URL(string: "\(DefaultAPIEnvironment.basePath)/api/messages/send/\(message.receiverId)")
            
            var urlRequest = URLRequest(url: url!)
            urlRequest.httpMethod = "POST"
            
            if let token = UserDefaultsService.shared.getValue(key: UserDefaultsKeys.token) {
                urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            }
            
            let boundary = UUID().uuidString
            urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            
            var body = Data()
            
            let params: [String: Any] = [
                "senderId": message.senderId,
                "receiverId": message.receiverId,
                "message": message.message
            ]
            
            for (key, value) in params {
                body.append("--\(boundary)\r\n".data(using: .utf8)!)
                body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
                body.append("\(value)\r\n".data(using: .utf8)!)
            }
            
            if let fileData = imageData {
                body.append("--\(boundary)\r\n".data(using: .utf8)!)
                body.append("Content-Disposition: form-data; name=\"file\"; filename=\"image.jpeg\"\r\n".data(using: .utf8)!)
                body.append("Content-Type: application/octet-stream\r\n\r\n".data(using: .utf8)!)
                body.append(fileData)
                body.append("\r\n".data(using: .utf8)!)
            }
            
            body.append("--\(boundary)--\r\n".data(using: .utf8)!)
            
            urlRequest.httpBody = body
            
            let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    do {
                        let json = try JSON(data: data!)
                        let response = json["message"].stringValue == "Profile picture deleted succesfully"
                        if response {
                            promise(.success(true))
                        } else {
                            promise(.success(false))
                        }
                    } catch {
                        promise(.failure(error))
                    }
                }
            }
            
            dataTask.resume()
        }.eraseToAnyPublisher()
    }
    
    func deleteChat(conversationId: String) -> AnyPublisher<Bool, Error> {
        Future { promise in
            let url = URL(string: "\(DefaultAPIEnvironment.basePath)/api/messages/delete-conversation/\(conversationId)")
            
            var urlRequest = URLRequest(url: url!)
            urlRequest.httpMethod = "DELETE"
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            if let token = UserDefaultsService.shared.getValue(key: UserDefaultsKeys.token) {
                urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            }
            
            let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    do {
                        let json = try JSON(data: data!)
                        let response = json["message"].stringValue == "Conversation and associated messages deleted successfully"
                        if response {
                            promise(.success(true))
                        } else {
                            promise(.success(false))
                        }
                    } catch {
                        promise(.failure(error))
                    }
                }
            }
            dataTask.resume()
        }.eraseToAnyPublisher()
    }
    
    func getMessages(userId: String) -> AnyPublisher<[Message], Error> {
        Future { promise in
            let urlComponents = URLComponents(string: "\(DefaultAPIEnvironment.basePath)/api/messages/receive/\(userId)")
            
            var urlRequest = URLRequest(url: (urlComponents?.url)!)
            
            urlRequest.httpMethod = "GET"
            
            if let token = UserDefaultsService.shared.getValue(key: UserDefaultsKeys.token) {
                urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            }
            
            let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    do {
                        var arrayToReturn = [Message]()
                        let json = try JSON(data: data!)
                        for (_, item) in json {
                            let message = JSONParsers.parseJsonMessage(json: item)
                            arrayToReturn.append(message)
                        }
                        promise(.success(arrayToReturn))
                    } catch {
                        promise(.failure(error))
                    }
                }
            }
            dataTask.resume()
        }.eraseToAnyPublisher()
    }
}
