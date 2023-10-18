//
//  FavoriteItem.swift
//  CommuteFriend
//
//  Created by 박태현 on 2023/10/16.
//

import Foundation

struct FavoriteItem: Hashable {

    enum itemType: Hashable {
        case subway(target: SubwayTarget)
        case bus(target: BusTarget)
    }

    let id: String
    let stationTarget: itemType
    var isAlarm: Bool

    init(id: String = UUID().uuidString, stationTarget: itemType, isAlarm: Bool) {
        self.id = id
        self.stationTarget = stationTarget
        self.isAlarm = isAlarm
    }

}
