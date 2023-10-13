//
//  SubwayStationResponseDTO+Mapping.swift
//  CommuteMate
//
//  Created by 박태현 on 2023/09/27.
//

import Foundation

struct SubwayStationResponseDTO: DTOMapping {
    typealias DomainType = [SubwayStation]

    private let searchInfo: SearchInfoBySubwayNameServiceModel
    var stations: [SubwayStationDTO] { searchInfo.row }

    enum CodingKeys: String, CodingKey {
        case searchInfo = "SearchInfoBySubwayNameService"
    }

    func toDomain() -> DomainType {
        return stations.map { $0.toDomain() }
    }

}

extension SubwayStationResponseDTO {

    struct SearchInfoBySubwayNameServiceModel: Decodable {
        var row: [SubwayStationDTO]
    }

    struct SubwayStationDTO: DTOMapping {
        typealias DomainType = SubwayStation

        let stationName: String
        let lineNumber: String

        enum CodingKeys: String, CodingKey {
            case stationName = "STATION_NM"
            case lineNumber = "LINE_NUM"
        }

        func toDomain() -> DomainType {
            var transferredLineNumber = lineNumber
                .replacingOccurrences(of: "0", with: "")
                .replacingOccurrences(of: "호선", with: "")
            transferredLineNumber = "100" + transferredLineNumber

            return SubwayStation(
                name: stationName,
                lineNumber: SubwayLine(
                    rawValue: transferredLineNumber
                ) ?? .createSubwayLine(line: lineNumber),
                latPos: 0.0,
                lonPos: 0.0,
                upDownDirection: nil
            )
        }
    }

}
