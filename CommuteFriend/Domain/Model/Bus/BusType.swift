//
//  BusType.swift
//  CommuteMate
//
//  Created by 박태현 on 2023/09/30.
//

import Foundation

enum BusType: String {
    case 공항 = "1"
    case 마을 = "2"
    case 간선 = "3"
    case 지선 = "4"
    case 순환 = "5"
    case 광역 = "6"
    case 인천 = "7"
    case 경기 = "8"
    case 폐지 = "9"
    case 공용 = "0"

    var description: String {
        switch self {
        case .공항: return "공항"
        case .마을: return "마을"
        case .간선: return "간선"
        case .지선: return "지선"
        case .순환: return "순환"
        case .광역: return "광역"
        case .인천: return "인천"
        case .경기: return "경기"
        case .폐지: return "폐지"
        case .공용: return "공용"
        }
    }
}
