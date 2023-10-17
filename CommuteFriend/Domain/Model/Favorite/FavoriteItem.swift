//
//  FavoriteItem.swift
//  CommuteFriend
//
//  Created by 박태현 on 2023/10/16.
//

import Foundation

struct FavoriteItem<T: StationTarget>: Hashable {
    let id: String
    let stationTarget: T
    var isAlarm: Bool

    init(id: String = UUID().uuidString, stationTarget: T, isAlarm: Bool) {
        self.id = id
        self.stationTarget = stationTarget
        self.isAlarm = isAlarm
    }
}
