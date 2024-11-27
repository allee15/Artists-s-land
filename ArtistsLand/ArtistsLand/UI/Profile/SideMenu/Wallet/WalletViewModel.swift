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
    @Published var userInfo: User
    
    init(userInfo: User) {
        self.userInfo = userInfo
    }
    
    func startStripe() {
        
    }
}
