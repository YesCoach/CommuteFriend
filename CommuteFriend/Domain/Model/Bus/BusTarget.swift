//
//  BusTarget.swift
//  CommuteFriend
//
//  Created by 박태현 on 2023/10/17.
//

import Foundation

struct BusTarget: StationTarget {
    var id: String
    let stationID: String // arsID: 정류소 번호
    let stationName: String
    let direction: String // @@방면
    let busRouteID: String?
    let busRouteName: String?
}
