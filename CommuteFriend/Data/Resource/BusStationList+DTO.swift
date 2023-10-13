//
//  BusStationResult.swift
//  CommuteFriend
//
//  Created by 박태현 on 2023/10/12.
//

import Foundation

// MARK: - BusStationList
struct BusStationList: Codable {
    let description: Description
    let data: [BusStationData]

    enum CodingKeys: String, CodingKey {
        case description = "DESCRIPTION"
        case data = "DATA"
    }
}

extension BusStationList {

    // MARK: - BusStation

    struct BusStationData: Codable, DTOMapping {
        typealias DomainType = BusStation

        let sttnNo: String
        let sttnNm: String
        let sttnID: Int
        let crdntX, crdntY: Double

        enum CodingKeys: String, CodingKey {
            case sttnNo = "sttn_no"
            case sttnNm = "sttn_nm"
            case sttnID = "sttn_id"
            case crdntX = "crdnt_x"
            case crdntY = "crdnt_y"
        }

        func toDomain() -> BusStation {
            return BusStation(
                id: String(sttnID),
                name: sttnNm,
                arsID: sttnNo,
                direction: ""
            )
        }
    }

    // MARK: - Description
    struct Description: Codable {
        let crdntY, businfoFcltInstlYn, crdntX, sttnType: String
        let sttnNo, sttnNm, sttnID: String

        enum CodingKeys: String, CodingKey {
            case crdntY = "CRDNT_Y"
            case businfoFcltInstlYn = "BUSINFO_FCLT_INSTL_YN"
            case crdntX = "CRDNT_X"
            case sttnType = "STTN_TYPE"
            case sttnNo = "STTN_NO"
            case sttnNm = "STTN_NM"
            case sttnID = "STTN_ID"
        }
    }
}
