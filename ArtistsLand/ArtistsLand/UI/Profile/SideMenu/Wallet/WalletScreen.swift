//
//  WalletScreen.swift
//  ArtistsLand
//
//  Created by Alexia Aldea on 06.11.2024.
//

import SwiftUI

struct WalletScreen: View {
    @EnvironmentObject private var navigation: Navigation
    private let mainNavigation = EnvironmentObjects.navigation
    @StateObject var viewModel: WalletViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            LeftNavBarView(title: "Your wallet") {
                navigation.pop(animated: true)
            }
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    HStack {
                        Spacer()
                        VStack(alignment: .center, spacing: 12) {
                            HStack(spacing: 0) {
                                Text("Balance: \(String(format: "%.1f", viewModel.userInfo.balance))")
                                    .font(.poppinsSemiBold(size: 20))
                                    .foregroundStyle(Color.mainBlack)
                                    .padding(.horizontal, 16)
                                
                                Image(.icCoins)
                                    .resizable()
                                    .renderingMode(.template)
                                    .foregroundStyle(Color.mainBlack)
                                    .frame(width: 20, height: 20)
                            }
                            
                            Text("Level: \(viewModel.userInfo.level)")
                                .font(.poppinsRegular(size: 16))
                                .foregroundStyle(Color.mainBlack)
                                .padding([.bottom, .horizontal], 20)
                        }
                        Spacer()
                    }
                    
                    Text("Buy tokens, level up and increase the chances for your posts to appear the firsts on feed.")
                        .font(.poppinsSemiBold(size: 12))
                        .foregroundStyle(Color.mainBlack)
                        .multilineTextAlignment(.leading)
                        .padding([.bottom, .horizontal], 16)
                    
                    ScrollView(showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 12) {
                            ForEach(viewModel.amounts, id: \.self) { amount in
                                TokenCardTypeView(amount: amount) {
                                    viewModel.startStripe(amount: amount)
                                }
                            }
                        }.padding(.horizontal, 16)
                            .padding(.top, 12)
                    }.padding(.bottom, 32)
                }.padding(.top, 16)
            }
        }.background(Color.mainWhite)
            .ignoresSafeArea(.container, edges: [.bottom, .horizontal])
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onReceive(viewModel.eventSubject) { event in
                switch event {
                case .completed:
                    navigation.pop(animated: true)
                    ToastManager.instance.show(
                        Toast(
                            text: "Payment successful!",
                            textColor: Color.lightGreen
                        ))
                case .error:
                    let modal = ModalChooseOptionView(title: "Something went wrong",
                                                      description: "An error has occured and we couldn't complete the action. Please try again later.",
                                                      topButtonText: "Back") {
                        navigation.dismissModal(animated: true, completion: nil)
                    }
                    navigation.presentPopup(modal.asDestination(), animated: true, completion: nil)
                }
            }
    }
}

fileprivate struct TokenCardTypeView: View {
    let amount: Int64
    let action: () -> ()
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 12) {
                Text("Tokens: \(amount) €")
                    .font(.poppinsRegular(size: 16))
                    .foregroundStyle(Color.mainBlack)
                    .multilineTextAlignment(.center)
                
                Text("For each 5 tokens bought, you'll advance 10 points in level.")
                    .font(.poppinsRegular(size: 12))
                    .foregroundStyle(Color.mainBlack)
                    .multilineTextAlignment(.leading)
            }
            
            Spacer()
            
            SmallClearButton(text: "Buy",
                        colorText: Color.mainWhite,
                        bgColor: Color.pink5Custom) {
                action()
            }.padding(.top, 16)
        }.padding(.all, 20)
            .background(Color.mainWhite)
            .border(Color.pink5Custom, width: 1, cornerRadius: 4)
    }
}
