//
//  SearchViewModel.swift
//  ArtistsLand
//
//  Created by Alexia Aldea on 17.10.2024.
//

import Foundation
import Combine

enum SearchScreenState {
    case emptyQuery
    case results
    case noResults
    case notEnoughCharacters
}

class SearchViewModel: BaseViewModel {
    var postsService = PostsService.shared
    @Published var searchText: String = ""
    @Published var searchScreenState: SearchScreenState = .emptyQuery
    @Published var results: [String] = []
    @Published var page: Int = 1
    @Published var isLoadingFirstTime: Bool = false
    @Published var isLoading: Bool = false
    
    private var searchPostsCancellable: AnyCancellable?
    private var articlesPerPage = 11
    @Published var hasLoadedInitially = false
    
    func resetForNewSearch() {
        if hasLoadedInitially {
            self.page = 1
            self.results = []
            self.hasLoadedInitially = false
            self.searchScreenState = .emptyQuery
            searchPostsCancellable?.cancel()
        }
    }
    
    func loadPosts(removePastResults: Bool = false) {
        searchPostsCancellable?.cancel()
        guard searchText.count > 2 else {
            self.searchScreenState = .notEnoughCharacters
            return
        }
        
        if !hasLoadedInitially && searchText.count > 2 {
            isLoadingFirstTime = true
        } else if hasLoadedInitially {
            self.isLoading = true
        }
        
        if removePastResults {
            self.results = []
            self.isLoading = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.isLoadingFirstTime = false
            self.hasLoadedInitially = true
            self.results = resultsMocked
            self.searchScreenState = .results
        }
//        searchPostsCancellable = postsService.getSearchPosts(searchItem: searchText)
//            .sink(receiveCompletion: { [weak self] _ in
//                guard let self else {return}
//                self.isLoadingFirstTime = false
//                self.hasLoadedInitially = true
//                self.isLoading = false
//            }, receiveValue: { [weak self] posts in
//                guard let self = self else { return }
//                if posts.isEmpty {
//                    self.searchScreenState = .noResults
//                } else {
//                    self.searchScreenState = .results
//                    self.results = [posts]
//                }
//            })
        
        self.searchPostsCancellable?.store(in: &bag)
    }
}
