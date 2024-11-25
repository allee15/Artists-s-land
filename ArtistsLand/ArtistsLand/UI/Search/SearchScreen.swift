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
            LeftNavBarView(title: "Search", hasBackButton: false) {}
            
            VStack(spacing: 0) {
                FloatingField(text: $viewModel.searchText,
                              placeHolder: "Search in app users",
                              icon: .icNavClose,
                              leftIcon: .icSearch,
                              leftIconHeight: 16)
                .padding(.horizontal, 16)
                .submitLabel(.search)
                .onSubmit {
                    viewModel.loadPosts(removePastResults: true)
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
                                VStack(alignment: .leading, spacing: 16) {
                                    ForEach(viewModel.results, id: \.id) { result in
                                        HStack {
                                            Button {
                                                let vm = ArtistProfileViewModel(artistId: Int64(result.id) ?? 0)
                                                navigation.push(ArtistProfileScreen(viewModel: vm).asDestination(), animated: true)
                                            } label: {
                                                ChatPicPlaceHolder(name: result.nickname, fontSize: 24, avatarUrl: result.avatarUrl, width: 64)
                                            }
                                            Spacer()
                                        }
                                    }
                                }.padding(.top, 24)
                                    .padding([.horizontal, .bottom], 16)
                            }
                        } else {
                            Spacer()
                        }
                    case .noResults:
                        NoSearchResultsView(title: "No results according to your search")
                    case .notEnoughCharacters:
                        NoSearchResultsView(title: "You must type at least 3 characters")
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
                    viewModel.loadPosts(removePastResults: true)
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
