//
//  BusTarget.swift
//  CommuteFriend
//
//  Created by 박태현 on 2023/10/17.
//

import Foundation

struct BusTarget: StationTarget {
    let id: String
    let stationID: String // arsID: 정류소 번호
    let stationName: String
    let direction: String // @@방면
    let busRouteID: String
    let busRouteName: String
    let busType: BusType
    let latPos: Double
    let lonPos: Double

    init(
        id: String = UUID().uuidString,
        stationID: String,
        stationName: String,
        direction: String,
        busRouteID: String?,
        busRouteName: String?,
        busType: BusType?,
        latPos: Double,
        lonPos: Double
    ) {
        self.id = id
        self.stationID = stationID
        self.stationName = stationName
        self.direction = direction
        self.busRouteID = busRouteID ?? ""
        self.busRouteName = busRouteName ?? ""
        self.busType = busType ?? .공용
        self.latPos = latPos
        self.lonPos = lonPos
    }
}
