//
//  SubwayArrivalCode.swift
//  CommuteMate
//
//  Created by 박태현 on 2023/09/28.
//

import Foundation

enum SubwayArrivalCode: String {
    case enter = "0"
    case arrive = "1"
    case leave = "2"
    case presLeave = "3"
    case presEnter = "4"
    case presArrive = "5"
    case move = "99"

    var description: String {
        switch self {
        case .enter:
            return "열차가 들어오고 있어요"
        case .arrive:
            return "열차가 도착했어요"
        case .leave:
            return "열차가 떠났어요"
        case .presLeave:
            return "열차가 이전역에서 출발했어요"
        case .presEnter:
            return "열차가 이전역에 진입했어요"
        case .presArrive:
            return "열차가 이전역에 도착했어요"
        case .move:
            return "열차가 이동하고 있어요"
        }
    }

    var shortDescription: String {
        switch self {
        case .enter:
            return "진입"
        case .arrive:
            return "도착"
        case .leave:
            return "출발"
        case .presLeave:
            return "전역 출발"
        case .presEnter:
            return "전역 진입"
        case .presArrive:
            return "전역 도착"
        case .move:
            return "이동중"
        }
    }
}
