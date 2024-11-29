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
            
            if let token = UserDefaultsService.shared.getValue(key: Key<String>(value: "jwtToken")) {
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
    
    func sendMessage() {
        
    }
    
    func deleteChat() {
        
    }
    
    func getMessages() {
        
    }
    
    func createChat(artistId: Int) {
        
    }
}
