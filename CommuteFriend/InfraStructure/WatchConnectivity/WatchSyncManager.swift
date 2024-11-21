//
//  WatchSyncManager.swift
//  CommuteFriend
//
//  Created by 박태현 on 11/21/24.
//

import WatchConnectivity

final class WatchSyncManager: NSObject {

    static let shared = WatchSyncManager()

    private var session: WCSession?

    override init() {
        super.init()

        if WCSession.isSupported() {
            session = WCSession.default
            session?.delegate = self
            session?.activate()
        }
    }

    func sendSubwayFavoriteItems(_ favoriteItems: [FavoriteItem]) {
        let items = favoriteItems
            .map { FavoriteSubwayCodable(favoriteItem: $0) }
            .compactMap { $0 }
        guard let data = try? items.asDictionary() else { return }
        session?.transferUserInfo([WatchConstants.UserInfo.FAVORITE_SUBWAY: data])
    }

    func sendBusFavoriteItems(_ favoriteItems: [FavoriteItem]) {
        let items = favoriteItems
            .map { FavoriteBusCodable(favoriteItem: $0) }
            .compactMap { $0 }
        guard let data = try? items.asDictionary() else { return }
        session?.transferUserInfo([WatchConstants.UserInfo.FAVORITE_BUS: data])
    }

}

extension WatchSyncManager: WCSessionDelegate {

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: (any Error)?) {

    }

    func sessionDidBecomeInactive(_ session: WCSession) {

    }

    func sessionDidDeactivate(_ session: WCSession) {

    }

}
