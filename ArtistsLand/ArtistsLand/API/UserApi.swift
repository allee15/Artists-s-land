//
//  UserApi.swift
//  ArtistsLand
//
//  Created by Alexia Aldea on 18.10.2024.
//

import Foundation
import Combine
import SwiftyJSON

class UserApi {
    func login(email: String, password: String) -> Future<User, Error> {
        Future { promise in
            var urlComponents = URLComponents(string: "\(DefaultAPIEnvironment.basePath)")
            
            urlComponents?.queryItems = [
                URLQueryItem(name: "email", value: email),
                URLQueryItem(name: "password", value: password)
            ]
            
            var urlRequest = URLRequest(url: (urlComponents?.url)!)
            
            urlRequest.httpMethod = "GET"
            
            let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    do {
                        let json = try JSON(data: data!)
                        let user = JSONParsers.parseJsonUser(json: json)
                        promise(.success(user))
                    } catch {
                        promise(.failure(error))
                    }
                }
            }
            dataTask.resume()
        }
    }
    
    func getUser() -> Future<User, Error> {
        Future { promise in
            
            var urlComponents = URLComponents(string: "\(DefaultAPIEnvironment.basePath)")
            
            urlComponents?.queryItems = [
                URLQueryItem(name: "", value: "")
            ]
            
            var urlRequest = URLRequest(url: (urlComponents?.url)!)
            
            urlRequest.httpMethod = "GET"
            
            let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    do {
                        let json = try JSON(data: data!)
                        let user = JSONParsers.parseJsonUser(json: json)
                        promise(.success(user))
                    } catch {
                        promise(.failure(error))
                    }
                }
            }
            dataTask.resume()
        }
    }
    
    func register(nickname: String, email: String, password: String, userType: String) -> Future<User, Error> {
        Future { promise in
            var urlComponents = URLComponents(string: "\(DefaultAPIEnvironment.basePath)")
            
            urlComponents?.queryItems = [
                URLQueryItem(name: "nickname", value: nickname),
                URLQueryItem(name: "email", value: email),
                URLQueryItem(name: "password", value: password),
                URLQueryItem(name: "userType", value: userType)
            ]
            
            var urlRequest = URLRequest(url: (urlComponents?.url)!)
            
            urlRequest.httpMethod = "GET"
            
            let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    do {
                        let json = try JSON(data: data!)
                        let user = JSONParsers.parseJsonUser(json: json)
                        promise(.success(user))
                    } catch {
                        promise(.failure(error))
                    }
                }
            }
            dataTask.resume()
        }
    }
    
    func deleteAccount() -> Future<Bool, Error> {
        Future { promise in
            var urlComponents = URLComponents(string: "\(DefaultAPIEnvironment.basePath)")
            
            urlComponents?.queryItems = []
            
            var urlRequest = URLRequest(url: (urlComponents?.url)!)
            
            urlRequest.httpMethod = "GET"
            
            let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    do {
                        let json = try JSON(data: data!)
                        let response = json["response"].boolValue
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
        }
    }
    
    func changePassword(newPassword: String) -> Future<Bool, Error> {
        Future { promise in
            var urlComponents = URLComponents(string: "\(DefaultAPIEnvironment.basePath)")
            
            urlComponents?.queryItems = [
                URLQueryItem(name: "newPassword", value: newPassword)
            ]
            
            var urlRequest = URLRequest(url: (urlComponents?.url)!)
            
            urlRequest.httpMethod = "POST"
            
            let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    do {
                        let json = try JSON(data: data!)
                        let response = json["response"].boolValue
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
        }
    }
    
    func editAccount(nickname: String) -> Future<Bool, Error> {
        Future { promise in
            var urlComponents = URLComponents(string: "\(DefaultAPIEnvironment.basePath)")
            
            urlComponents?.queryItems = [
                URLQueryItem(name: "nickname", value: nickname)
            ]
            
            var urlRequest = URLRequest(url: (urlComponents?.url)!)
            
            urlRequest.httpMethod = "POST"
            
            let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    do {
                        let json = try JSON(data: data!)
                        let response = json["response"].boolValue
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
        }
    }
    
    func getBalance() -> Future<Int64, Error> {
        Future { promise in
            var urlComponents = URLComponents(string: "\(DefaultAPIEnvironment.basePath)")
            
            urlComponents?.queryItems = []
            
            var urlRequest = URLRequest(url: (urlComponents?.url)!)
            
            urlRequest.httpMethod = "GET"
            
            let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    do {
                        let json = try JSON(data: data!)
                        promise(.success(json["response"]["balance"].int64Value)) 
                    } catch {
                        promise(.failure(error))
                    }
                }
            }
            dataTask.resume()
        }
    }
    
    func updateProfileImage(id: Int, avatar: Data?, shouldDeleteAvatar: Bool?) -> Future<Bool, Error> {
        Future { promise in
            var urlComponents = URLComponents(string: "\(DefaultAPIEnvironment.basePath)")
            
            var urlRequest = URLRequest(url: (urlComponents?.url)!)
            
            urlRequest.httpMethod = "POST"
            
            let boundary = "Boundary-\(UUID().uuidString)"
            urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            
            var body = Data()
            
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"id\"\r\n\r\n".data(using: .utf8)!)
            body.append("\(id)".data(using: .utf8)!)
            body.append("\r\n".data(using: .utf8)!)
            
            if let shouldDeleteAvatar = shouldDeleteAvatar {
                body.append("--\(boundary)\r\n".data(using: .utf8)!)
                body.append("Content-Disposition: form-data; name=\"shouldDeleteAvatar\"\r\n\r\n".data(using: .utf8)!)
                body.append("\(shouldDeleteAvatar)".data(using: .utf8)!)
                body.append("\r\n".data(using: .utf8)!)
            }
            
            if let avatar = avatar {
                body.append("--\(boundary)\r\n".data(using: .utf8)!)
                body.append("Content-Disposition: form-data; name=\"avatar\"; filename=\"avatar.jpg\"\r\n".data(using: .utf8)!)
                body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
                body.append(avatar)
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
                        let response = json["response"].boolValue
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
        }
    }
    
    func getArtistInfo(artistId: Int64) {
        
    }
}
