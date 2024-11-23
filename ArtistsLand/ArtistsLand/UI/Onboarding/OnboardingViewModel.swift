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
        OnboardingData(image: .imgOnboarding1,
                       title: "Welcome to Artists's land!",
                       description: "The best community for artists all over the world!"),
        OnboardingData(image: .imgOnboarding2,
                       title: "Discover new ways of art",
                       description: "Search, scroll and discover the creations of other artists!"),
        OnboardingData(image: .imgOnboarding3,
                       title: "Connect with other artists",
                       description: "Discuss with them, ask questions, exchange experiences and maybe even help them grow as artists!")
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
