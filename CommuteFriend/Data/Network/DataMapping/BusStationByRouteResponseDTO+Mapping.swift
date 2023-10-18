//
//  BusStationByRouteResponseDTO+Mapping.swift
//  CommuteMate
//
//  Created by 박태현 on 2023/10/04.
//

import Foundation

struct BusStationByRouteResponseDTO: Decodable {
    let msgBody: BusStationResponseItemListModel
}

extension BusStationByRouteResponseDTO {

    struct BusStationResponseItemListModel: Decodable {
        var itemList: [BusStationDTO]?
    }

    struct BusStationDTO: DTOMapping {
        typealias DomainType = BusStation

        let id: String
        let name: String
        let descriptionID: String
        let direction: String

        enum CodingKeys: String, CodingKey {
            case id = "station"
            case name = "stationNm"
            case descriptionID = "arsId"
            case direction
        }

        func toDomain() -> BusStation {
            return BusStation(
                id: id,
                name: name,
                arsID: descriptionID,
                direction: direction
            )
        }
    }
}
