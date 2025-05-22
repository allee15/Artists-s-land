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
        ZStack {
            if viewModel.pageIndex < 2 {
                VStack {
                    HStack {
                        CloseButton()
                        Spacer()
                    }
                    .padding(.horizontal, 16)
                    Spacer()
                }
            }
            
            TabView(selection: $viewModel.pageIndex) {
                ForEach(0..<3) { index in
                    OnboardingPageView(page: viewModel.onboardingPages[index],
                                       index: index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .ignoresSafeArea(.container, edges: [.bottom])
            
            VStack {
                Spacer()
                HStack {
                    if viewModel.pageIndex == 2 {
                        Button {
                            viewModel.goToTabBar()
                        } label: {
                            Text("Skip")
                                .font(.poppinsRegular(size: 16))
                                .foregroundColor(Color.mainWhite)
                                .lineLimit(1)
                                .fixedSize(horizontal: false, vertical: true)
                                .padding(.vertical, 8)
                                .padding(.horizontal, 12)
                                .background(Color.pink3Custom)
                                .padding(.bottom, 8)
                        }
                    }
                    
                    Spacer()
                    
                    NavSliderView(currentStep: viewModel.pageIndex) {
                        viewModel.nextPage()
                    }
                    .padding(.bottom, 8)
                    
                    Spacer()
                    
                    if viewModel.pageIndex == 2 {
                        Button {
                            viewModel.goToLogin()
                        } label: {
                            Text("Login")
                                .font(.poppinsRegular(size: 16))
                                .foregroundColor(Color.mainWhite)
                                .lineLimit(1)
                                .fixedSize(horizontal: false, vertical: true)
                                .padding(.vertical, 8)
                                .padding(.horizontal, 12)
                                .background(Color.pink3Custom)
                                .padding(.bottom, 8)
                        }
                    }
                }
                .padding(.horizontal, 40)
            }
        }
        .background(Color.lightPinkCustom)
        .ignoresSafeArea(.container, edges: [.horizontal])
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
    let index: Int
    
    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .center, spacing: 40) {
                    Text(page.title)
                        .font(.poppinsSemiBold(size: 36))
                        .foregroundStyle(Color.mainBlack)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.horizontal, 16)
                    
                    Text(page.description)
                        .font(.poppinsRegular(size: 16))
                        .foregroundStyle(Color.mainBlack)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.horizontal, 16)
                }
                .padding(.top, 24)
            }
            
            Image(page.image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea(.container, edges: [.bottom])
        }
    }
}

fileprivate struct NavSliderView: View {
    let currentStep: Int
    let buttonAction: () -> ()
    
    var body: some View {
        HStack(spacing: 12) {
            ForEach(0..<3) { step in
                Button {
                    buttonAction()
                } label: {
                    Circle()
                        .fill(step == currentStep ? Color.mainWhite : Color(hex: "#FFFCFC").opacity(0.6))
                        .frame(height: 12)
                        .aspectRatio(1, contentMode: .fit)
                }
            }
        }
        
    }
}
