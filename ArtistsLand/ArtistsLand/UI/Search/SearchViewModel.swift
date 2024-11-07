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
    
    func loadArticles(removePastResults: Bool = false) {
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
        
//        searchPostsCancellable = articlesService.getSearchArticles(perPage: articlesPerPage,
//                                                                      page: page,
//                                                                      searchItem: searchText)
//        .sink(receiveCompletion: { [weak self] completion in
//            guard let self else {return}
//            self.isLoadingFirstTime = false
//            self.hasLoadedInitially = true
//            self.isLoading = false
//            switch completion {
//            case .finished:
//                break
//            case .failure(let failure):
//                self.emitError(error: failure)
//            }
//        }, receiveValue: {[weak self] articles in
//            guard let self else {return}
//            if page == 1 && articles.isEmpty {
//                self.searchScreenState = .noResults
//            } else {
//                self.searchScreenState = .results
//                self.results.append(contentsOf: articles)
//            }
//        })
        
        self.searchPostsCancellable?.store(in: &bag)
    }
}
