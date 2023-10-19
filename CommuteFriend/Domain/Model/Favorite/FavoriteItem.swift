//
//  FavoriteItem.swift
//  CommuteFriend
//
//  Created by 박태현 on 2023/10/16.
//

import Foundation

struct FavoriteItem: Hashable {

    let id: String
    let stationTarget: StationTargetType
    var isAlarm: Bool

    init(id: String = UUID().uuidString, stationTarget: StationTargetType, isAlarm: Bool) {
        self.id = id
        self.stationTarget = stationTarget
        self.isAlarm = isAlarm
    }

}
