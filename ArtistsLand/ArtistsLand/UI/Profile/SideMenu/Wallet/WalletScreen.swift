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
                                Text("Your balance: \(String(format: "%.1f", viewModel.userInfo.balance))")
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
                                .font(.poppinsSemiBold(size: 16))
                                .foregroundStyle(Color.mainBlack)
                                .padding([.bottom, .horizontal], 20)
                        }
                        Spacer()
                    }
                    
                    Text("Buy tokens, level up and increase the chances for your posts to appear the firsts on feed.")
                        .font(.poppinsRegular(size: 16))
                        .foregroundStyle(Color.mainBlack)
                        .multilineTextAlignment(.leading)
                        .padding([.bottom, .horizontal], 16)
                    
                    VStack(spacing: 0) {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(viewModel.amounts, id: \.self) { amount in
                                    TokenCardTypeView(amount: amount) {
                                        viewModel.startStripe(amount: amount)
                                    }.frame(width: (UIScreen.main.bounds.size.width - 32) / 2.35 )
                                }
                            }.padding(.horizontal, 16)
                                .padding(.top, 12)
                            
                        }.padding(.bottom, 32)
                    }
                }.padding(.top, 16)
            }
        }.background(Color.mainWhite)
            .ignoresSafeArea(.container, edges: [.bottom, .horizontal])
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

fileprivate struct TokenCardTypeView: View {
    let amount: Int64
    let action: () -> ()
    
    var body: some View {
        VStack(spacing: 0) {
            Text("Tokens:")
                .font(.poppinsRegular(size: 16))
                .foregroundStyle(Color.mainBlack)
                .multilineTextAlignment(.center)
                .padding(.bottom, 16)
            
            Text("\(amount) €")
                .font(.poppinsSemiBold(size: 32))
                .foregroundStyle(Color.mainBlack)
                .padding(.bottom, 4)
            
            Text("For each 5 tokens bought, you'll advance 10 points in level.")
                .font(.poppinsRegular(size: 12))
                .foregroundStyle(Color.mainBlack)
                .multilineTextAlignment(.center)
            
            BlueButtonView(text: "Buy") {
                action()
            }.padding(.top, 16)
        }.padding(.all, 20)
            .background(Color.mainGray)
            .border(Color.mainGray, width: 1, cornerRadius: 8)
            .padding(.bottom, 4)
    }
}
