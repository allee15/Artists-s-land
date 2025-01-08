//
//  StripeApi.swift
//  ArtistsLand
//
//  Created by Alexia Aldea on 08.01.2025.
//

import Foundation
import Combine
import SwiftyJSON

class StripeApi {
    func createPaymentIntent(amount: Int64, currency: String) -> AnyPublisher<String, Error> {
        Future { promise in
            
            let urlComponents = URLComponents(string: "\(DefaultAPIEnvironment.basePath)/api/stripe/create-payment-intent")
            
            var urlRequest = URLRequest(url: (urlComponents?.url)!)
            
            urlRequest.httpMethod = "POST"
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let body: [String: Any] = [
                "amount": amount * 100,
                "currency": currency
            ]
            
            if let token = UserDefaultsService.shared.getValue(key: UserDefaultsKeys.token) {
                urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            }
            
            urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: body)
            
            let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    do {
                        let json = try JSON(data: data!)
                        let token = JSONParsers.parseJsonStripe(json: json)
                        promise(.success(token))
                    } catch {
                        promise(.failure(error))
                    }
                }
            }
            dataTask.resume()
        }.eraseToAnyPublisher()
    }
}
