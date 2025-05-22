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
                              colors: (bgColor: Color.lightPinkCustom,
                                       borderColor: Color.pink5Custom,
                                       placeholderForeground: Color.black),
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
                                                let vm = ArtistProfileViewModel(artistId: result.id)
                                                navigation.push(ArtistProfileScreen(viewModel: vm).asDestination(), animated: true)
                                            } label: {
                                                ChatPicPlaceHolder(name: result.nickname, avatarUrl: result.avatarUrl)
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
                        NoSearchResultsView(title: "No results according to your search", image: .icNoResults2)
                    case .notEnoughCharacters:
                        NoSearchResultsView(title: "You must type at least 3 characters", image: .icNoResults)
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
    let image: ImageResource
    
    var body: some View {
        HStack {
            Spacer()
            VStack(spacing: 24) {
                Spacer()
                
                Image(image)
                    .resizable()
                    .renderingMode(.template)
                    .foregroundStyle(Color.mainBlack)
                    .aspectRatio(contentMode: .fit)
                    .frame(height: UIScreen.main.bounds.height * 0.15)
                
                Text(title)
                    .font(.poppinsRegular(size: 16))
                    .foregroundStyle(Color.mainBlack)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 16)
                
                Spacer()
            }
            Spacer()
        }.padding(.horizontal, 16)
    }
}
