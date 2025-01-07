//
//  PostsApi.swift
//  ArtistsLand
//
//  Created by Alexia Aldea on 08.11.2024.
//

import Foundation
import Combine
import SwiftyJSON

class PostsApi {
    
    func getUserPosts() -> AnyPublisher<[Post], Error> {
        Future { promise in
            
            let urlComponents = URLComponents(string: "\(DefaultAPIEnvironment.basePath)/api/user/get-user-posts")
            
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
                        let json = try JSON(data: data!)
                        let posts = JSONParsers.parseJsonPosts(json: json)
                        promise(.success(posts))
                    } catch {
                        promise(.failure(error))
                    }
                }
            }
            dataTask.resume()
        }.eraseToAnyPublisher()
    }
    
    func uploadPost(imageData: Data, description: String) -> AnyPublisher<Bool, Error> {
        Future { promise in
            
            let url = URL(string: "\(DefaultAPIEnvironment.basePath)/api/user/add-post")
            
            var urlRequest = URLRequest(url: url!)
            urlRequest.httpMethod = "POST"

            let boundary = UUID().uuidString
            urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            
            if let token = UserDefaultsService.shared.getValue(key: UserDefaultsKeys.token) {
                urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            }
            
            var body = Data()
            
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"post\"; filename=\"post.jpg\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
            body.append(imageData)
            body.append("\r\n".data(using: .utf8)!)
            
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"description\"\r\n\r\n".data(using: .utf8)!)
            body.append(description.data(using: .utf8)!)
            body.append("\r\n".data(using: .utf8)!)
            
            body.append("--\(boundary)--\r\n".data(using: .utf8)!)
            
            urlRequest.httpBody = body
            
            let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    do {
                        let json = try JSON(data: data!)
                        let response = json["message"].stringValue == "Post updated successfully"
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
    
    func deletePost(postId: String) -> AnyPublisher<Bool, Error> {
        Future { promise in
            let url = URL(string: "\(DefaultAPIEnvironment.basePath)/api/user/delete-post/\(postId)")
            
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
                        let response = json["message"].stringValue == "Post deleted succesfully"
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
    
    func getArtistPosts(artistId: String) -> AnyPublisher<[Post], Error> {
        Future { promise in
            
            let urlComponents = URLComponents(string: "\(DefaultAPIEnvironment.basePath)/api/user/get-user/posts/\(artistId)")
            
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
                        let json = try JSON(data: data!)
                        let posts = JSONParsers.parseJsonPosts(json: json)
                        promise(.success(posts))
                    } catch {
                        promise(.failure(error))
                    }
                }
            }
            dataTask.resume()
        }.eraseToAnyPublisher()
    }
    
    
    func likePost(postId: String) -> AnyPublisher<Bool, Error> {
        return Future { promise in
            
            let urlComponents = URLComponents(string: "\(DefaultAPIEnvironment.basePath)/api/user/like-post/\(postId)")
            
            var urlRequest = URLRequest(url: (urlComponents?.url)!)
            
            urlRequest.httpMethod = "POST"
            
            if let token = UserDefaultsService.shared.getValue(key: UserDefaultsKeys.token) {
                urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            }
            
            let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    do {
                        let json = try JSON(data: data!)
                        let response = json["message"].stringValue == "Post liked succesfully"
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
    
    func unlikePost(postId: String) -> AnyPublisher<Bool, Error> {
        return Future { promise in
            
            let urlComponents = URLComponents(string: "\(DefaultAPIEnvironment.basePath)/api/user/delete-like-post/\(postId)")
            
            var urlRequest = URLRequest(url: (urlComponents?.url)!)
            
            urlRequest.httpMethod = "DELETE"
            
            if let token = UserDefaultsService.shared.getValue(key: UserDefaultsKeys.token) {
                urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            }
            
            let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    do {
                        let json = try JSON(data: data!)
                        let response = json["message"].stringValue == "Post unliked succesfully"
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
    
    func addCommentToPost(comment: String, postId: String) -> AnyPublisher<Bool, Error> {
        return Future { promise in
            
            let urlComponents = URLComponents(string: "\(DefaultAPIEnvironment.basePath)/api/user/add-comment-post/\(postId)")
            
            var urlRequest = URLRequest(url: (urlComponents?.url)!)
            
            let body: [String: Any] = ["message": comment]
            let jsonData = try? JSONSerialization.data(withJSONObject: body)
            
            urlRequest.httpMethod = "POST"
            
            if let token = UserDefaultsService.shared.getValue(key: UserDefaultsKeys.token) {
                urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            }
            
            urlRequest.httpBody = jsonData
            
            let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    do {
                        let json = try JSON(data: data!)
                        let response = json["message"].stringValue == "Commented on post succesfully"
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
    
    func reportPost(postId: String) {
        
    }
}
