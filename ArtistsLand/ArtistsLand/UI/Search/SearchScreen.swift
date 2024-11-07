//
//  SearchScreen.swift
//  ArtistsLand
//
//  Created by Alexia Aldea on 17.10.2024.
//

import SwiftUI

struct SearchScreen: View {
    @EnvironmentObject private var navigation: Navigation
    @StateObject private var viewModel = SearchViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            LeftNavBarView(title: "Search", hasBackButton: false) {
                hideKeyboard()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    navigation.pop(animated: true)
                }
            }
            
            VStack(spacing: 24) {
                FloatingField(text: $viewModel.searchText,
                              placeHolder: "Search in app users",
                              icon: .icNavClose,
                              leftIcon: .icSearch,
                              leftIconHeight: 16)
                .padding(.horizontal, 16)
                .submitLabel(.search)
                .onSubmit {
                    viewModel.loadArticles(removePastResults: true)
                }
                
                if viewModel.isLoadingFirstTime {
                    VStack{
                        Spacer()
                        LoaderView()
                        Spacer()
                    }
                } else {
                    switch viewModel.searchScreenState {
                    case .emptyQuery:
                        VStack {
                            EmptyView()
                            Spacer()
                        }
                    case .results:
                        if !viewModel.results.isEmpty {
                            ScrollView(showsIndicators: false) {
                                //Posts
                            }
                        } else {
                            Spacer()
                        }
                    case .noResults:
                        NoSearchResultsView(title: "No results from your search")
                    case .notEnoughCharacters:
                        NoSearchResultsView(title: "You must enter at least 3 characters")
                    }
                }
            }
            .padding(.top, 20)
        }.background(Color.mainWhite)
            .ignoresSafeArea(.container, edges: [.bottom, .horizontal])
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onChange(of: viewModel.searchText) { _, _ in
                viewModel.resetForNewSearch()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    viewModel.loadArticles(removePastResults: true)
                }
            }
    }
}

fileprivate struct NoSearchResultsView: View {
    let title: String
    
    var body: some View {
        HStack {
            Spacer()
            VStack(spacing: 24) {
                Spacer()
                
                Image(.icNoResults)
                    .resizable()
                    .renderingMode(.template)
                    .foregroundStyle(Color.mainBlueInversat)
                    .aspectRatio(contentMode: .fit)
                    .frame(height: UIScreen.main.bounds.height * 0.15)
                
                Text(title)
                    .font(.poppinsBold(size: 16))
                    .foregroundStyle(Color.mainBlack)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 16)
                
                Spacer()
            }
            Spacer()
        }.padding(.horizontal, 16)
    }
}
