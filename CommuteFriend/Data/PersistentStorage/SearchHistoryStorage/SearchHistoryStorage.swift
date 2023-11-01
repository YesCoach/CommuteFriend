//
//  SearchHistoryStorage.swift
//  CommuteFriend
//
//  Created by 박태현 on 2023/10/12.
//

import Foundation

protocol SearchHistoryStorage {
    func saveSearchHistoryList(historyList: [String], type: SearchHistoryType)
    func loadSearchHistoryList(type: SearchHistoryType) -> [String]
}
