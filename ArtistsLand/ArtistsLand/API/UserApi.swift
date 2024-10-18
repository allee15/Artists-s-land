//
//  UserApi.swift
//  ArtistsLand
//
//  Created by Alexia Aldea on 18.10.2024.
//

import Foundation
import Combine

class UserApi {
    func getUser() -> Future<User, Error> {
        Future { promise in
            var urlComponents = URLComponents(string: "")
            
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
//                        var arrayToReturn = [Airport]()
//                        let json = try JSON(data: data!)
//                        let airports = json["response"]
//                        for (_, item) in airports {
//                            let airport = Airport(name: item["name"].stringValue,
//                                                   iataCode: item["iata_code"].stringValue,
//                                                   icaoCode: item["icao_code"].stringValue,
//                                                   latitude: item["lat"].doubleValue,
//                                                   longitude: item["lng"].doubleValue,
//                                                   countryCode: item["country_code"].stringValue)
//                            arrayToReturn.append(airport)
//                        }
//                        promise(.success(arrayToReturn))
                        
//                        let json = try JSON(data: data)
//                        let data = json["query"].stringValue
//                        let monument = Monument(description: data)
//                        
//                        promise(.success(monument))
                        
                    } catch {
                        promise(.failure(error))
                    }
                }
            }
            dataTask.resume()
        }
    }
}
