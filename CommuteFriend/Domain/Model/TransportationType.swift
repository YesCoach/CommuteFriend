//
//  TransportationType.swift
//  CommuteFriend
//
//  Created by 박태현 on 2023/10/11.
//

import Foundation

enum TransportationType {

    case subway
    case bus

    var description: String {
        switch self {
        case .subway:
            return "지하철"
        case .bus:
            return "버스"
        }
    }

    var imageName: String {
        switch self {
        case .subway:
            return "tram.fill"
        case .bus:
            return "bus.fill"
        }
    }
}
