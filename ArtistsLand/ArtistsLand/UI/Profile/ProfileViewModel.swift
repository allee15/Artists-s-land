//
//  ProfileViewModel.swift
//  ArtistsLand
//
//  Created by Alexia Aldea on 17.10.2024.
//

import Foundation
import UIKit

class ProfileViewModel: BaseViewModel {
    let userInfo: User? = user
    @Published var profileImage: UIImage?
    
    func updateProfileImage(id: Int, shouldDeleteAvatar: Bool? = nil) {
        
    }
}
