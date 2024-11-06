//
//  SideMenuViewModel.swift
//  ArtistsLand
//
//  Created by Alexia Aldea on 06.11.2024.
//

import Foundation
import Combine

enum LogOutCompletion {
    case logout
    case delete
    case failure(Error)
}

class SideMenuViewModel: BaseViewModel {
    let userInfo: User? = user
    var appVersion: String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "Unknown"
        return "\(version) \(build)"
    }
    let eventSubject = PassthroughSubject<LogOutCompletion, Never>()
    
    func logOut() {
        self.eventSubject.send(.logout)
    }
    
    func deleteAccount() {
        self.eventSubject.send(.delete)
    }
}
