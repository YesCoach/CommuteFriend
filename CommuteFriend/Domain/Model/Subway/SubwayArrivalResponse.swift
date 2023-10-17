//
//  File.swift
//  CommuteFriend
//
//  Created by 박태현 on 2023/10/15.
//

import Foundation

struct StationArrivalResponse: Hashable {

    enum ArrivalTarget: Hashable {
        case subway(target: SubwayTarget)
        case bus(target: BusTarget)
    }

    enum Arrival: Hashable {
        case subway(arrival: [SubwayArrival])
        case bus(arrival: BusArrival)
    }

    let stationArrivalTarget: ArrivalTarget
    let stationArrival: Arrival

//    let subwayArrival: [SubwayArrival]?
}
