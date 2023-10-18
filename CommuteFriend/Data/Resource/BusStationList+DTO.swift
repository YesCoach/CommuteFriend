//
//  BusStationResult.swift
//  CommuteFriend
//
//  Created by 박태현 on 2023/10/12.
//

import Foundation

// MARK: - BusStationList
struct BusStationList: Decodable {
    let description: Description
    let data: [BusStationData]

    enum CodingKeys: String, CodingKey {
        case description = "DESCRIPTION"
        case data = "DATA"
    }
}

extension BusStationList {

    // MARK: - BusStation

    struct BusStationData: Decodable, DTOMapping {

        enum StationType: String, Decodable {
            case ghost = "가상정류장"
            case maeul = "마을버스"
            case normal = "일반차로"
            case centeral = "중앙차로"
            case roadsideHour = "가로변시간"
            case roadsideDay = "가로변전일"
        }

        typealias DomainType = BusStation

        let sttnNo: String
        let sttnNm: String
        let sttnID: Int
        let crdntX, crdntY: Double
        let sttnType: StationType?

        enum CodingKeys: String, CodingKey {
            case sttnNo = "sttn_no"
            case sttnNm = "sttn_nm"
            case sttnID = "sttn_id"
            case crdntX = "crdnt_x"
            case crdntY = "crdnt_y"
            case sttnType = "sttn_type"
        }

        func toDomain() -> BusStation {
            return BusStation(
                id: String(sttnID),
                name: sttnNm,
                arsID: sttnNo,
                direction: "",
                latPos: crdntY,
                lonPos: crdntX
            )
        }
    }

    // MARK: - Description
    struct Description: Decodable {
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
