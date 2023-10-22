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

        var stationName: String {
            switch self {
            case .subway(let target): return target.name
            case .bus(let target): return target.stationID
            }
        }

        var stationLine: String {
            switch self {
            case .subway(let target): return target.lineNumber.description
            case .bus(let target): return target.busRouteName
            }
        }

        var lineColorName: String {
            switch self {
            case .subway(let target): return target.lineNumber.rawValue
            case .bus(let target): return target.busType.description
            }
        }

        var directionType: String {
            switch self {
            case .subway(let target): return target.destinationName
            case .bus(let target): return target.direction
            }
        }
    }

    enum Arrival: Hashable {
        case subway(arrival: [SubwayArrival])
        case bus(arrival: [BusArrival])
    }

    let stationArrivalTarget: ArrivalTarget
    let stationArrival: Arrival
}
