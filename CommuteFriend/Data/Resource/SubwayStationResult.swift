//
//  SubwayStationResult.swift
//  CommuteFriend
//
//  Created by 박태현 on 2023/10/12.
//

import Foundation

// MARK: - SubwayStationList

struct SubwayStationList: Hashable, Codable {
    let description: Description
    let data: [SubwayStationDTO]

    enum CodingKeys: String, CodingKey {
        case description = "DESCRIPTION"
        case data = "DATA"
    }
}

// MARK: - SubwayStationDTO

struct SubwayStationDTO: Hashable, Codable, DTOMapping {

    typealias DomainType = SubwayStation

    let lineNum: String
    let stationNmChn, stationCD, stationNmJpn, stationNmEng: String
    let stationNm, frCode: String

    enum CodingKeys: String, CodingKey {
        case lineNum = "line_num"
        case stationNmChn = "station_nm_chn"
        case stationCD = "station_cd"
        case stationNmJpn = "station_nm_jpn"
        case stationNmEng = "station_nm_eng"
        case stationNm = "station_nm"
        case frCode = "fr_code"
    }

    func toDomain() -> DomainType {
        var transferredLineNumber = lineNum
            .replacingOccurrences(of: "0", with: "")
            .replacingOccurrences(of: "호선", with: "")
        transferredLineNumber = "100" + transferredLineNumber

        return SubwayStation(
            name: stationNm,
            lineNumber: SubwayLine(
                rawValue: transferredLineNumber
            ) ?? .createSubwayLine(line: lineNum),
            upDownDirection: nil
        )
    }
}

// MARK: - Description

struct Description: Hashable, Codable {
    let stationNm, stationCD, stationNmChn, lineNum: String
    let frCode, stationNmJpn, stationNmEng: String

    enum CodingKeys: String, CodingKey {
        case stationNm = "STATION_NM"
        case stationCD = "STATION_CD"
        case stationNmChn = "STATION_NM_CHN"
        case lineNum = "LINE_NUM"
        case frCode = "FR_CODE"
        case stationNmJpn = "STATION_NM_JPN"
        case stationNmEng = "STATION_NM_ENG"
    }
}
