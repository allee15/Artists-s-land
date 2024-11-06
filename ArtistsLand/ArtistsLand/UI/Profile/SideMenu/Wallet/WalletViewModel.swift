//
//  WalletViewModel.swift
//  ArtistsLand
//
//  Created by Alexia Aldea on 06.11.2024.
//

import Foundation

class WalletViewModel: BaseViewModel {
    let amounts: [Int] = [5, 10, 15, 20, 25]
    @Published var balance: Int = 0
    @Published var level: Int = 0
    
    override init() {
        super.init()
        getBalance()
    }
    
    func getBalance() {
        //userService.getBalance()
        self.balance = 250
        self.level = balance / 50
    }
    
    func startStripe() {
        
    }
}
