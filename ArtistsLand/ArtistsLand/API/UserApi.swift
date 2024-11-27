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
    func login(email: String, password: String) -> AnyPublisher<UserResponse, Error> {
        Future { promise in
            let url = URL(string: "\(DefaultAPIEnvironment.basePath)/api/auth/login")
            
            let body: [String: Any] = [
                "email": email,
                "password": password
            ]
            
            let jsonData = try? JSONSerialization.data(withJSONObject: body)
            
            guard let url = url else {return}
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "POST"
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.httpBody = jsonData
            
            let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    do {
                        let json = try JSON(data: data!)
                        let user = JSONParsers.parseJsonUserResponse(json: json)
                        promise(.success(user))
                    } catch {
                        promise(.failure(error))
                    }
                }
            }
            dataTask.resume()
        }.eraseToAnyPublisher()
    }
    
    func getUser() -> AnyPublisher<User, Error> {
        Future { promise in
            
            let urlComponents = URLComponents(string: "\(DefaultAPIEnvironment.basePath)/api/user/get-user")
            
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
                        let json = try JSON(data: data!)
                        let user = JSONParsers.parseJsonUser(json: json)
                        promise(.success(user))
                    } catch {
                        promise(.failure(error))
                    }
                }
            }
            dataTask.resume()
        }.eraseToAnyPublisher()
    }
    
    func register(nickname: String, email: String, password: String, userType: String) -> AnyPublisher<UserResponse, Error> {
        Future { promise in
            let url = URL(string: "\(DefaultAPIEnvironment.basePath)/api/auth/register")
            
            let body: [String: Any] = [
                "username": nickname,
                "email": email,
                "password": password,
                "accType": userType
            ]
            
            let jsonData = try? JSONSerialization.data(withJSONObject: body)
            
            guard let url = url else {return}
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "POST"
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.httpBody = jsonData
            
            let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    do {
                        let json = try JSON(data: data!)
                        let user = JSONParsers.parseJsonUserResponse(json: json)
                        promise(.success(user))
                    } catch {
                        promise(.failure(error))
                    }
                }
            }
            dataTask.resume()
        }.eraseToAnyPublisher()
    }
    
    func logout() -> AnyPublisher<Bool, Error> {
        Future { promise in
            let urlComponents = URLComponents(string: "\(DefaultAPIEnvironment.basePath)/api/auth/logout")
            
            var urlRequest = URLRequest(url: (urlComponents?.url)!)
            
            urlRequest.httpMethod = "POST"
            
            let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                        UserDefaultsService.shared.setValue(key: Key<String>(value: "jwtToken"), value: nil)
                        
                        promise(.success(true))
                    } else {
                        promise(.success(false))
                    }
                }
            }
            
            dataTask.resume()
        }.eraseToAnyPublisher()
    }
    
    func deleteAccount() -> AnyPublisher<Bool, Error> {
        Future { promise in
            let urlComponents = URLComponents(string: "\(DefaultAPIEnvironment.basePath)/api/user/delete-account")
            
            var urlRequest = URLRequest(url: (urlComponents?.url)!)
            
            urlRequest.httpMethod = "DELETE"
            
            let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    do {
                        let json = try JSON(data: data!)
                        let response = json["message"].stringValue == "Account deleted successfully"
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
    
    func changePassword(newPassword: String, currentPassword: String) -> AnyPublisher<Bool, Error> {
        Future { promise in
            let urlComponents = URLComponents(string: "\(DefaultAPIEnvironment.basePath)/api/user/change-password")
            
            var urlRequest = URLRequest(url: (urlComponents?.url)!)
            urlRequest.httpMethod = "PUT"
            
            let body: [String: Any] = [
                "currentPassword": currentPassword,
                "newPassword": newPassword,
                "confirmNewPassword": newPassword
            ]
            
            urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            
            let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    do {
                        let json = try JSON(data: data!)
                        let response = json["message"].stringValue == "The password was changed succesfully"
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
    
    func editAccount(nickname: String?, email: String?) -> AnyPublisher<Bool, Error> {
        Future { promise in
            let urlComponents = URLComponents(string: "\(DefaultAPIEnvironment.basePath)/api/user/edit-acc")
            
            var urlRequest = URLRequest(url: (urlComponents?.url)!)
            urlRequest.httpMethod = "PUT"
            
            var body: [String: Any] = [:]
            
            if let nickname = nickname {
                body["username"] = nickname
            }
            
            if let email = email {
                body["email"] = email
            }
            
            urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    do {
                        let json = try JSON(data: data!)
                        let response = json["message"].stringValue == "The account was edited succesfully"
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
    
    func uploadProfilePicture(imageData: Data) -> AnyPublisher<Bool, Error> {
        Future { promise in
            
            let url = URL(string: "\(DefaultAPIEnvironment.basePath)/api/user/profile-pic")
            
            var urlRequest = URLRequest(url: url!)
            urlRequest.httpMethod = "POST"

            let boundary = UUID().uuidString
            urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

            var body = Data()

            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"profilePic\"; filename=\"avatar.jpg\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
            body.append(imageData)
            body.append("\r\n".data(using: .utf8)!)

            body.append("--\(boundary)--\r\n".data(using: .utf8)!)

            urlRequest.httpBody = body

            let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    do {
                        let json = try JSON(data: data!)
                        let response = json["message"].stringValue == "Profile photo updated successfully"
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

    func deleteProfilePicture() -> AnyPublisher<Bool, Error> {
        Future { promise in
            let url = URL(string: "\(DefaultAPIEnvironment.basePath)/api/user/profile-pic")
            
            var urlRequest = URLRequest(url: url!)
            
            urlRequest.httpMethod = "DELETE"
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            if let token = UserDefaultsService.shared.getValue(key: Key<String>(value: "jwtToken")) {
                urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            }

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
    
    func getAllUsers() -> AnyPublisher<[User], Error> {
        Future { promise in
            
            let urlComponents = URLComponents(string: "\(DefaultAPIEnvironment.basePath)/api/user/get-users")
            
            var urlRequest = URLRequest(url: (urlComponents?.url)!)
            
            urlRequest.httpMethod = "GET"
            
            let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    do {
                        var arrayToReturn = [User]()
                        let json = try JSON(data: data!)
                        for (_, item) in json {
                            let user = JSONParsers.parseJsonUser(json: item)
                            arrayToReturn.append(user)
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
    
    func getArtistInfo(artistId: Int64) {
        
    }
}
