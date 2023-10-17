//
//  SearchHistoryRepository.swift
//  CommuteFriend
//
//  Created by 박태현 on 2023/10/12.
//

import Foundation

final class SearchHistoryRepository {

    private let searchHistoryStorage: SearchHistoryStorage

    init(searchHistoryStorage: SearchHistoryStorage = UserDefaultsSearchHistory()) {
        self.searchHistoryStorage = searchHistoryStorage
    }

}

extension SearchHistoryRepository {

    func saveSearchHistoryList(historyList: [String], type: SearchHistoryType) {
        searchHistoryStorage.saveSearchHistoryList(historyList: historyList, type: type)
    }

    func loadSearchHistoryList(type: SearchHistoryType) -> [String] {
        return searchHistoryStorage.loadSearchHistoryList(type: type)
    }

}
