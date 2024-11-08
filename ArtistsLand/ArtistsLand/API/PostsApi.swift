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
    func getSearchPosts(searchItem: String) -> Future<String, Error> { //todo fix returned object
        Future { promise in
            var urlComponents = URLComponents(string: "\(DefaultAPIEnvironment.basePath)")
            
            urlComponents?.queryItems = [
                URLQueryItem(name: "searchItem", value: searchItem)
            ]
            
            var urlRequest = URLRequest(url: (urlComponents?.url)!)
            
            urlRequest.httpMethod = "GET"
            
            let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    do {
                        let json = try JSON(data: data!)
                        let response = json["search"].stringValue
                        promise(.success(response))
                    } catch {
                        promise(.failure(error))
                    }
                }
            }
            dataTask.resume()
        }
    }
}
