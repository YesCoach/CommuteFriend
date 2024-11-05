//
//  AnalyticsManager.swift
//  CommuteFriend
//
//  Created by 박태현 on 2023/11/26.
//

import Foundation
import FirebaseAnalytics

enum AnalyticsEvent {

    // MARK: - Subway Analytics

    case subwaySearch(station: String, line: String, destination: String)
    case subwayFavoriteEnroll(station: String, line: String, destination: String)

    case busSearch(station: String, line: String, destination: String)
    case busFavoriteEnroll(station: String, line: String, destination: String)

    var name: String {
        switch self {
        case .subwaySearch: return "subwaySearch"
        case .subwayFavoriteEnroll: return "subwayFavoriteEnroll"
        case .busSearch: return "busSearch"
        case .busFavoriteEnroll: return "busFavoriteEnroll"
        }
    }

    var parameters: [String : Any]? {
        switch self {
        case .subwaySearch(let station, let line, let destination):
            return [
                "station" : station,
                "line" : line,
                "destination" : destination
            ]
        case .subwayFavoriteEnroll(let station, let line, let destination):
            return [
                "station" : station,
                "line" : line,
                "destination" : destination
            ]
        case .busSearch(let station, let line, let destination):
            return [
                "station" : station,
                "line" : line,
                "destination" : destination
            ]
        case .busFavoriteEnroll(let station, let line, let destination):
            return [
                "station" : station,
                "line" : line,
                "destination" : destination
            ]
        }
    }

}

final class AnalyticsManager {

    static let shared = AnalyticsManager()

    private init() { }

    func log(event: AnalyticsEvent) {
        Analytics.logEvent(event.name, parameters: event.parameters)
    }

}
