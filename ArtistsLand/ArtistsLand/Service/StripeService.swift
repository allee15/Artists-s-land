//
//  StripeService.swift
//  ArtistsLand
//
//  Created by Alexia Aldea on 08.01.2025.
//

import Foundation
import Combine

class StripeService {
    static let shared = StripeService()
    private let stripeApi = StripeApi()
    var bag = Set<AnyCancellable>()
    
    private init() { }
    
    func createPaymentIntent(amount: Int64, currency: String, userId: String) -> AnyPublisher<String, Error> {
        return stripeApi.createPaymentIntent(amount: amount, currency: currency, userId: userId)
            .eraseToAnyPublisher()
    }
}
