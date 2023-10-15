//
//  File.swift
//  CommuteFriend
//
//  Created by 박태현 on 2023/10/15.
//

import Foundation

struct StationArrivalResponse: Hashable {
    let stationArrivalTarget: SubwayTarget

    let subwayArrival: [SubwayArrival]?
}
