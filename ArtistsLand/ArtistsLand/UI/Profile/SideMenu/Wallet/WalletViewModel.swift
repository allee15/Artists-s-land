//
//  WalletViewModel.swift
//  ArtistsLand
//
//  Created by Alexia Aldea on 06.11.2024.
//

import Foundation
import StripePaymentSheet
import UIKit

class WalletViewModel: BaseViewModel {
    var userService = UserService.shared
    var stripeService = StripeService.shared
    
    let amounts: [Int64] = [5, 10, 15, 20, 25]
    @Published var userInfo: User
    
    init(userInfo: User) {
        self.userInfo = userInfo
    }
    
    func startStripe(amount: Int64) {
        stripeService.createPaymentIntent(amount: amount, currency: "eur")
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure(let error) = completion {
                    print("Failed to fetch Payment Intent: \(error.localizedDescription)")
                }
            }, receiveValue: { [weak self] clientSecret in
                guard let self else {return}
                self.presentPaymentSheet(clientSecret: clientSecret)
            })
            .store(in: &bag)
    }
    
    private func presentPaymentSheet(clientSecret: String?) {
        guard let clientSecret = clientSecret else { return }
        
        PaymentController.presentPaymentSheet(clientSecret: clientSecret)
    }
}
