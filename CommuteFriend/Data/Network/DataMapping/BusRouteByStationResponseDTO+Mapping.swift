//
//  BusRouteByStationResponseDTO+Mapping.swift
//  CommuteFriend
//
//  Created by 박태현 on 2023/10/17.
//

import Foundation

struct BusRouteByStationResponseDTO: Decodable {
    let msgBody: BusRouteResponseItemListModel
}

extension BusRouteByStationResponseDTO {

    struct BusRouteResponseItemListModel: Decodable {
        var itemList: [BusDTO]?
    }

    struct BusDTO: DTOMapping {
        typealias DomainType = Bus

        var busRouteID, busRouteNm, busRouteAbrv, length: String?
        var busRouteType, stBegin, stEnd, term: String?
        var nextBus, firstBusTm, lastBusTm, firstBusTmLow, lastBusTmLow: String?

        enum CodingKeys: String, CodingKey {
            case busRouteID = "busRouteId"
            case busRouteNm, busRouteAbrv, length, busRouteType,
                 stBegin, stEnd, term, nextBus, firstBusTm,
                 lastBusTm, firstBusTmLow, lastBusTmLow
        }

        func toDomain() -> Bus {
            return Bus(
                id: busRouteID ?? "''",
                kind: BusType(rawValue: busRouteType ?? "") ?? .간선,
                name: busRouteNm ?? "",
                direction: "123"
            )
        }
    }
}
