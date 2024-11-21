//
//  WatchSyncManager.swift
//  CommuteFriend
//
//  Created by 박태현 on 11/21/24.
//

import Foundation
import WatchConnectivity

final class WatchSyncManager: NSObject, ObservableObject {

    static let shared = WatchSyncManager()

    private var session: WCSession?

    private let userDefaults = UserDefaults.standard

    override init() {
        super.init()
        if WCSession.isSupported() {
            session = WCSession.default
            session?.delegate = self
            session?.activate()
        }
    }

    func getFavoriteSubway() -> [FavoriteItem] {
        guard let data = userDefaults.data(forKey: WatchConstants.UserInfo.FAVORITE_SUBWAY),
              let stations = try? JSONDecoder().decode([FavoriteSubwayCodable].self, from: data)
        else { return [] }
        return stations.map { $0.toDomain() }
    }

    func getFavoriteBus() -> [FavoriteItem] {
        guard let data = userDefaults.data(forKey: WatchConstants.UserInfo.FAVORITE_BUS),
              let stations = try? JSONDecoder().decode([FavoriteBusCodable].self, from: data)
        else { return [] }
        return stations.map { $0.toDomain() }
    }

}

extension WatchSyncManager: WCSessionDelegate {

    func session(_ session: WCSession, didReceiveMessage message: [String: Any]) { }
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {
        if let dic = userInfo[WatchConstants.UserInfo.FAVORITE_SUBWAY] as? [String: Any],
           let data = try? JSONSerialization.data(withJSONObject: dic),
           let _ = try? JSONDecoder().decode([FavoriteSubwayCodable].self, from: data)
        {
            userDefaults.set(data, forKey: WatchConstants.UserInfo.FAVORITE_SUBWAY)
        } else
        if let dic = userInfo[WatchConstants.UserInfo.FAVORITE_BUS] as? [String: Any],
           let data = try? JSONSerialization.data(withJSONObject: dic),
           let _ = try? JSONDecoder().decode([FavoriteBusCodable].self, from: data)
        {
            userDefaults.set(data, forKey: WatchConstants.UserInfo.FAVORITE_BUS)
        }
    }

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: (any Error)?) { }

}
