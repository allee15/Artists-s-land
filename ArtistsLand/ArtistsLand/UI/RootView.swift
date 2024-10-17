//
//  Rootview.swift
//  ArtistsLand
//
//  Created by Alexia Aldea on 17.10.2024.
//

import SwiftUI
import Network
import Combine

enum RootViewModelEvent {
    case goToTabBar
    case goToLogin
    case goToOnboarding
}

class RootViewModel: BaseViewModel {
    let eventSubject = PassthroughSubject<RootViewModelEvent, Never>()
    
    private var binded = false
    
    @Published var showBlockingError: Bool = false
    @Published var isLoadingBinding: Bool = false
    
    override init() {
        super.init()
        applyTheme()
        setupErrorHandling()
    }
    
    func bind() {
        showBlockingError = false
        
        guard !binded else {return}
        binded = true
        self.eventSubject.send(.goToTabBar)
//        loadSubject(publisher: userService.userReactiveData.getStateSubject()) { [weak self] state in
//            guard let self else {return}
//            switch state {
//            case .failure:
//                self.isLoadingBinding = false
//                self.showBlockingError = true
//                self.binded = false
//            case .loading:
//                self.isLoadingBinding = true
//            case .ready(let userState):
//                self.isLoadingBinding = false
//                self.showBlockingError = false
//                switch userState {
//                case .anonymous:
//                    if self.propertyStorage.getOnboardingStatus() {
//                        self.emitEvent(.goToTabBar)
//                    } else {
//                        self.emitEvent(.goToOnboarding)
//                    }
//                case .loggedIn(_):
//                    if case .anonymous = self.lastUserState {
//                        self.emitEvent(.goToTabBar)
//                    }
//                }
//
//                self.lastUserState = userState
//            }
//        }
    }
    
    func setupErrorHandling() {
//        noInternetInterceptor.errors()
//            .receive(on: DispatchQueue.main)
//            .sink { [weak self] errorEvent in
//                self?.showBlockingError = true
//            }
//            .store(in: &bag)
    }
    
    func retryBinding() {
        showBlockingError = false
        isLoadingBinding = true
        
        bind()
    }
    
    func applyTheme() {
//        let key: Key<String> = Key(value: StorageKeys.appTheme)
//        if let themeString = propertyStorage.getValue(key: key),
//           let theme = SchemeType(rawValue: themeString) {
//            switch theme {
//            case .light:
//                applyUserInterfaceStyle(.light)
//            case .dark:
//                applyUserInterfaceStyle(.dark)
//            case .system:
//                applyUserInterfaceStyle(.unspecified)
//            }
//        } else {
//            applyUserInterfaceStyle(.unspecified)
//        }
    }
    
    private func applyUserInterfaceStyle(_ style: UIUserInterfaceStyle) {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            for window in windowScene.windows {
                window.overrideUserInterfaceStyle = style
            }
        }
    }
}

struct RootView: View {
    private let mainNavigation = EnvironmentObjects.navigation
    let navigation: Navigation
    
    @StateObject private var viewModel = RootViewModel()
    
    @ObservedObject private var toastManager = ToastManager.instance
    
    var body: some View {
        ControllerRepresentable(controller: navigation.navigationController)
            .ignoresSafeArea()
            .onReceive(viewModel.eventSubject, perform: { event in
                switch event {
                case .goToTabBar:
                    TabBarCoordinator.instance.tabBarNavigation = .home
                    navigation.replaceNavigationStack([TabBarScreen().asDestination()], animated: true)
                case .goToLogin:
                    break
//                    navigation.replaceNavigationStack([LoginScreen().asDestination(tag: "login")], animated: true)
                case .goToOnboarding:
                    break
//                    navigation.push(OnboardingScreen().asDestination(), animated: true)
                }
            }).onAppear {
                viewModel.bind()
            }
            .overlay(
                VStack {
                    if let toast = toastManager.toast {
                        ToastView(toast: toast)
                            .padding(SafeAreaInsets)
                            .transition(.move(edge: .top))
                            .onTapGesture {
                                toastManager.hideToast()
                            }.gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
                                .onEnded({ value in
                                    if value.translation.height < 0 {
                                        toastManager.hideToast()
                                    }
                                }))
                    }
                    Spacer()
                }
                    .ignoresSafeArea()
                    .animation(.easeIn(duration: 0.25), value: toastManager.toast)
            )
            .overlay {
                VStack {
                    if viewModel.showBlockingError {
//                        BlockingErrorScreen(isLoading: viewModel.isLoadingBinding) {
//                            viewModel.retryBinding()
//                        }
                    }
                }
            }
    }
}
