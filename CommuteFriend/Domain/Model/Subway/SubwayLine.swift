//
//  SubwayLine.swift
//  CommuteMate
//
//  Created by 박태현 on 2023/09/28.
//

import Foundation

enum SubwayLine: String {
    case number1 = "1001"
    case number2 = "1002"
    case number3 = "1003"
    case number4 = "1004"
    case number5 = "1005"
    case number6 = "1006"
    case number7 = "1007"
    case number8 = "1008"
    case number9 = "1009"
    case central = "1061"
    case gyeonguiCentral = "1063"
    case airport = "1065"
    case gyeongchun = "1067"
    case suinBundang = "1075"
    case shinBundang = "1077"
    case gyeongGang = "1081"
    case uiSinseol = "1092"
    case seohae = "1093"

    var lineNum: String {
        switch self {
        case .number1: return "1"
        case .number2: return "2"
        case .number3: return "3"
        case .number4: return "4"
        case .number5: return "5"
        case .number6: return "6"
        case .number7: return "7"
        case .number8: return "8"
        case .number9: return "9"
        case .central:
            return "중앙선"
        case .gyeonguiCentral:
            return "경의선"
        case .airport:
            return "공항철도"
        case .gyeongchun:
            return "경춘선"
        case .suinBundang:
            return "수인분당선"
        case .shinBundang:
            return "신분당선"
        case .gyeongGang:
            return "경강선"
        case .uiSinseol:
            return "우이신설경전철"
        case .seohae:
            return "서해선"

        }
    }

    static func createSubwayLine(line: String) -> SubwayLine {
        if let subwayLine = SubwayLine(rawValue: line) {
            return subwayLine
        }
        switch line {
        case "중앙선": return .central
        case "경의선": return .gyeonguiCentral
        case "공항철도": return .airport
        case "경춘선": return .gyeongchun
        case "수인분당선": return .suinBundang
        case "신분당선": return .shinBundang
        case "경강선": return .gyeongGang
        case "우이신설경전철": return .uiSinseol
        case "서해선": return .seohae
        default: return .number3
        }
    }
}
