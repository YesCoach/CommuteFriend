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
    let statnCode: String
    let statnX, statnY: Double
    let isSplit: String

    let statnUpCode: String
    let statnDownCode: String
    let statnSplitCode: String?

    enum CodingKeys: String, CodingKey {
        case subwayID = "SUBWAY_ID"
        case statnID = "STATN_ID"
        case statnNm = "STATN_NM"
        case subwayName = "SUBWAY_NAME"
        case statnCode = "STATN_CODE"
        case statnX = "STATN_X"
        case statnY = "STATN_Y"
        case isSplit = "IS_SPLIT"
        case statnUpCode = "UP_CODE"
        case statnDownCode = "DOWN_CODE"
        case statnSplitCode = "SPLIT_CODE"
    }

    func toDomain() -> SubwayStation {
        return SubwayStation(
            name: statnNm,
            lineNumber: .init(rawValue: String(subwayID)) ?? .number1,
            code: statnCode,
            latPos: statnY,
            lonPos: statnX,
            isSplit: Bool(isSplit) ?? false,
            upStation: statnUpCode,
            downStation: statnDownCode,
            splitStation: statnSplitCode
        )
    }
}
