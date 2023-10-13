//
//  SubwayStationList.swift
//  CommuteFriend
//
//  Created by 박태현 on 2023/10/12.
//

import Foundation

typealias SubwayStationList = [SubwayStationListElement]

// MARK: - SubwayStationListElement
struct SubwayStationListElement: Codable, DTOMapping {
    typealias DomainType = SubwayStation

    let subwayID, statnID: Int
    let statnNm: String
    let subwayName: String
    let statnX, statnY: Double

    enum CodingKeys: String, CodingKey {
        case subwayID = "SUBWAY_ID"
        case statnID = "STATN_ID"
        case statnNm = "STATN_NM"
        case subwayName = "SUBWAY_NAME"
        case statnX = "STATN_X"
        case statnY = "STATN_Y"
    }

    func toDomain() -> SubwayStation {
        return SubwayStation(
            name: statnNm,
            lineNumber: .init(rawValue: String(subwayID)) ?? .number1,
            latPos: statnY,
            lonPos: statnX
        )
    }
}
