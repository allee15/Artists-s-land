//
//  OnboardingViewModel.swift
//  ArtistsLand
//
//  Created by Alexia Aldea on 18.10.2024.
//

import Foundation
import Combine

enum OnboardingState {
    case completed
    case goToTabBar
}

class OnboardingViewModel: BaseViewModel {
    var userDefaultsService = UserDefaultsService.shared
    
    @Published var pageIndex = 0
    let eventSubject = PassthroughSubject<OnboardingState, Never>()
    
    let onboardingPages: [OnboardingData] = [
        OnboardingData(image: .icHome,
                       title: "Titlu",
                       description: "Descriere"),
        OnboardingData(image: .icHome,
                       title: "Titlu2",
                       description: "Descriere"),
        OnboardingData(image: .icHome,
                       title: "Titlu3",
                       description: "Descriere")
    ]
    
    override init() {
        super.init()
    }
    
    func nextPage() {
        if pageIndex == onboardingPages.count - 1 {
            self.userDefaultsService.setOnboarding(onboardingIsOver: true)
            self.eventSubject.send(.completed)
        } else if pageIndex < onboardingPages.count - 1 {
            pageIndex += 1
        }
    }
    
    func goToLogin() {
        self.userDefaultsService.setOnboarding(onboardingIsOver: true)
    }
}
