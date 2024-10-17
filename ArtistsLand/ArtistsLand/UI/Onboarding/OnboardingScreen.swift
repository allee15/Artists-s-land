//
//  OnboardingScreen.swift
//  ArtistsLand
//
//  Created by Alexia Aldea on 18.10.2024.
//

import SwiftUI

struct OnboardingScreen: View {
    @StateObject private var viewModel = OnboardingViewModel()
    @EnvironmentObject private var navigation: Navigation
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack(spacing: 16) {
                HStack {
                    CloseButton() {
                        viewModel.goToLogin()
                    }
                    Spacer()
                }
                TabView(selection: $viewModel.pageIndex) {
                    ForEach(0..<3) { index in
                        OnboardingPageView(page: viewModel.onboardingPages[index])
                    }
                }.tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                
                VStack(spacing: 0) {
                    Spacer()
                    NavSliderView(currentStep: viewModel.pageIndex) {
                        viewModel.nextPage()
                    }
                }.padding(.horizontal, 24)
                    .padding(.bottom, 24)
            }
        }.background(Color.mainWhite)
            .ignoresSafeArea(.container, edges: [.bottom, .horizontal])
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onReceive(viewModel.eventSubject) { event in
                switch event {
                case .completed:
                    navigation.push(LoginScreen().asDestination(), animated: true)
                case .goToTabBar:
                    navigation.replaceNavigationStack([TabBarScreen().asDestination(tag: "home")], animated: true)
                
                }
            }
    }
}

fileprivate struct OnboardingPageView: View {
    let page: OnboardingData
    
    @EnvironmentObject private var navigation: Navigation
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 0) {
                let smallScreen = UIScreen.main.bounds.height <= 667
                
                HStack {
                    Spacer()
                    Image(page.image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: UIScreen.main.bounds.height * (1/(smallScreen ? 3.5 : 3)))
                        .padding(.bottom, 40)
                        .padding(.top, 64)
                    Spacer()
                }
                
                Text(page.title)
                    .font(.poppinsBold(size: 28))
                    .foregroundStyle(Color.mainBlack)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.bottom, 20)
                
                Text(page.description)
                    .font(.poppinsRegular(size: 14))
                    .tint(Color.mainBlack)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
                
                Spacer()
            }.padding(.horizontal, 24)
        }
    }
}

fileprivate struct NavSliderView: View {
    let currentStep: Int
    let buttonAction: () -> ()
    
    var body: some View {
        HStack(spacing: 0) {
            HStack(spacing: 8) {
                ForEach(0..<3) { step in
                    Button {
                        buttonAction()
                    } label: {
                        Circle()
                            .fill(step == currentStep ? Color.red : Color.gray)
                            .frame(height: 12)
                            .aspectRatio(1, contentMode: .fit)
                    }
                }
            }
            
            if currentStep == 2 {
                Button {
                    buttonAction()
                } label: {
                    Text("Intra in app")
                        .foregroundStyle(Color.mainBlack)
                }
            }
        }.background(Color.mainWhite)
    }
}
