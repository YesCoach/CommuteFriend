//
//  UserDefaultsSearchHistory.swift
//  CommuteFriend
//
//  Created by 박태현 on 2023/10/12.
//

import Foundation

final class UserDefaultsSearchHistory {

    private let userDefaults: UserDefaults

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

}

extension UserDefaultsSearchHistory: SearchHistoryStorage {

    func saveSearchHistoryList(historyList: [String], type: SearchHistoryType) {
        userDefaults.set(historyList, forKey: type.key)
    }

    func loadSearchHistoryList(type: SearchHistoryType) -> [String] {
        guard let data = userDefaults.object(forKey: type.key) as? [String]
        else { return [] }

        return data
    }

}
