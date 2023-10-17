//
//  SearchHistoryType.swift
//  CommuteFriend
//
//  Created by 박태현 on 2023/10/12.
//

import Foundation

enum SearchHistoryType {
    case subway
    case busByRoute
    case busByStation

    var key: String {
        switch self {
        case .subway:
            return "searchHistorySubway"
        case .busByRoute:
            return "searchHistoryBusByRoute"
        case .busByStation:
            return "searchHistoryBusByStation"
        }
    }
}
