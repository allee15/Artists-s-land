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
            VStack(spacing: 16) {
                HStack {
                    CloseButton() {
                        viewModel.goToLogin()
                    }
                    Spacer()
                }.padding(.horizontal, 20)
                
                TabView(selection: $viewModel.pageIndex) {
                    ForEach(0..<3) { index in
                        OnboardingPageView(page: viewModel.onboardingPages[index])
                    }
                }.tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                
                VStack(spacing: 0) {
                    NavSliderView(currentStep: viewModel.pageIndex) {
                        viewModel.nextPage()
                    }
                }.padding(.horizontal, 20)
                    .padding(.top, 20)
            }.padding(.bottom, 32)
            .background(Color.simpleBlue)
            .ignoresSafeArea(.container, edges: [.bottom, .horizontal])
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onReceive(viewModel.eventSubject) { event in
                switch event {
                case .completed:
                    navigation.push(LoginScreen().asDestination(), animated: true)
                case .goToTabBar:
                    navigation.replaceNavigationStack([TabBarScreen().asDestination()], animated: true)
                
                }
            }
    }
}

fileprivate struct OnboardingPageView: View {
    let page: OnboardingData
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    Spacer()
                    Image(page.image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: UIScreen.main.bounds.height / 2 )
                        .cornerRadius(8, corners: .allCorners)
                    Spacer()
                }
                
                Text(page.title)
                    .font(.poppinsBold(size: 28))
                    .foregroundStyle(Color(hex: "#84BABF"))
                    .fixedSize(horizontal: false, vertical: true)
                
                Text(page.description)
                    .font(.poppinsRegular(size: 14))
                    .foregroundStyle(Color(hex: "#84BABF"))
                    .fixedSize(horizontal: false, vertical: true)
                
                Spacer()
            }.padding(.horizontal, 20)
        }
    }
}

fileprivate struct NavSliderView: View {
    let currentStep: Int
    let buttonAction: () -> ()
    
    var body: some View {
        HStack {
            if currentStep == 2 {
                Button {
                    buttonAction()
                } label: {
                    Text("Login")
                        .font(.poppinsBold(size: 16))
                        .foregroundStyle(Color(hex: "#84BABF"))
                }.opacity(0)
            }
            
            Spacer()
            
            HStack(spacing: 8) {
                ForEach(0..<3) { step in
                    Button {
                        buttonAction()
                    } label: {
                        Circle()
                            .fill(step == currentStep ? Color(hex: "#085558") : Color(hex: "#84BABF"))
                            .frame(height: 12)
                            .aspectRatio(1, contentMode: .fit)
                    }
                }
            }
            
            Spacer()
            
            if currentStep == 2 {
                Button {
                    buttonAction()
                } label: {
                    Text("Login")
                        .font(.poppinsBold(size: 16))
                        .foregroundStyle(Color(hex: "#84BABF"))
                }
            }
        }
    }
}
