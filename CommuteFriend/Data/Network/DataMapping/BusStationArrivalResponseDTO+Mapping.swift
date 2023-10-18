//
//  BusStationArrivalResponseDTO+Mapping.swift
//  CommuteMate
//
//  Created by 박태현 on 2023/10/02.
//

import Foundation

struct BusStationArrivalResponseDTO: DTOMapping {
    typealias DomainType = [BusArrival]

    let msgBody: BusStationArrivalResponseItemListModel

    func toDomain() -> [BusArrival] {
        return (msgBody.itemList ?? []).map { $0.toDomain() }
    }
}

extension BusStationArrivalResponseDTO {
    struct BusStationArrivalResponseItemListModel: Decodable {
        var itemList: [BusStationArrivalDTO]?
    }

    struct BusStationArrivalDTO: DTOMapping {
        typealias DomainType = BusArrival

        let id: String
        let name: String
        let descriptionID: String
        let busRouteID: String
        let busRouteName: String
        let busTerm: String
        let busRouteType: String
        let nextBusTime: String
        let firstArrivalMessage: String
        let secondArrivalMessage: String
        let direction: String
        let nextStationName: String

        enum CodingKeys: String, CodingKey {
            case id = "stId"
            case name = "stNm"
            case descriptionID = "arsId"
            case busRouteID = "busRouteId"
            case busRouteName = "busRouteAbrv"
            case busTerm = "term"
            case busRouteType = "routeType"
            case nextBusTime = "nextBus"
            case firstArrivalMessage = "arrmsg1"
            case secondArrivalMessage = "arrmsg2"
            case direction = "adirection"
            case nextStationName = "nxtStn"
        }

        func toDomain() -> BusArrival {
            return .init(
                stationID: descriptionID,
                stationName: name,
                busRouteID: busRouteID,
                busRouteName: busRouteName,
                busRouteType: busRouteType,
                term: busTerm,
                direction: direction,
                nextStationName: nextStationName,
                firstArrivalMessage: firstArrivalMessage,
                secondArrivalMessage: secondArrivalMessage
            )
        }
    }
}
