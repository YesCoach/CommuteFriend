//
//  BusResponseDTO+Mapping.swift
//  CommuteFriend
//
//  Created by 박태현 on 2023/10/17.
//

import Foundation

struct BusResponseDTO: Decodable {
    let msgBody: BusResponseItemListModel
}

extension BusResponseDTO {

    struct BusResponseItemListModel: Decodable {
        var itemList: [BusDTO]?
    }

    struct BusDTO: DTOMapping {
        let id: String
        let name: String
        let type: String
        let startStation: String
        let endStation: String

        enum CodingKeys: String, CodingKey {
            case id = "busRouteId"
            case name = "busRouteNm"
            case type = "routeType"
            case startStation = "stStationNm"
            case endStation = "edStationNm"
        }

        func toDomain() -> Bus {
            return Bus(
                id: id,
                kind: BusType(rawValue: type) ?? .공용,
                name: name,
                direction: "\(startStation) ↔ \(endStation)"
            )
        }
    }
}

extension BusResponseDTO {
    func toDomain() -> [Bus] {
        return (msgBody.itemList ?? []).map { $0.toDomain() }
    }
}
