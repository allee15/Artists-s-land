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
    var userService = UserService.shared
    
    @Published var searchText: String = ""
    @Published var searchScreenState: SearchScreenState = .emptyQuery
    @Published var results: [User] = []
    @Published var isLoadingFirstTime: Bool = false
    @Published var isLoading: Bool = false
    
    private var searchPostsCancellable: AnyCancellable?
    @Published var hasLoadedInitially = false
    
    func resetForNewSearch() {
        if hasLoadedInitially {
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
        
        searchPostsCancellable = userService.getAllUsers()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] _ in
                guard let self else {return}
                self.isLoadingFirstTime = false
                self.hasLoadedInitially = true
                self.isLoading = false
            }, receiveValue: { [weak self] users in
                guard let self = self else { return }
                self.isLoading = false
                
                let filteredUsers = users.filter { user in
                    user.nickname.lowercased().contains(self.searchText.lowercased())
                }
                
                if filteredUsers.isEmpty {
                    self.searchScreenState = .noResults
                } else {
                    self.searchScreenState = .results
                    self.results = filteredUsers
                }
            })
        
        self.searchPostsCancellable?.store(in: &bag)
    }
}
