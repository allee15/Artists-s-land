//
//  Stripe.swift
//  ArtistsLand
//
//  Created by Alexia Aldea on 08.01.2025.
//

import UIKit
import Stripe
import StripePaymentSheet

class PaymentController {
    static func presentPaymentSheet(clientSecret: String) {
        var configuration = PaymentSheet.Configuration()
        configuration.merchantDisplayName = "ArtistsLand"
        
        let paymentSheet = PaymentSheet(paymentIntentClientSecret: clientSecret, configuration: configuration)
        
        DispatchQueue.main.async {
            if let rootController = UIApplication.shared.windows.first?.rootViewController {
                paymentSheet.present(from: rootController) { result in
                    switch result {
                    case .completed:
                        print("Plată completată!")
                    case .canceled:
                        print("Plata a fost anulată!")
                    case .failed(let error):
                        print("Eroare la plată: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
}
