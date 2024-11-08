//
//  WalletViewModel.swift
//  ArtistsLand
//
//  Created by Alexia Aldea on 06.11.2024.
//

import Foundation

class WalletViewModel: BaseViewModel {
    var userService = UserService.shared
    
    let amounts: [Int64] = [5, 10, 15, 20, 25]
    @Published var balance: Int64 = 0
    @Published var level: Int64 = 0
    
    override init() {
        super.init()
        getBalance()
    }
    
    private func getBalance() {
        self.balance = 400
        self.level = balance / 50
        userService.getBalance()
            .sink { _ in
                
            } receiveValue: { [weak self] balance in
                guard let self else {return}
                self.balance = balance
                self.level = balance / 50
            }.store(in: &bag)
    }
    
    func startStripe() {
        
    }
}
