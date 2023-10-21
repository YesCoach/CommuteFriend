//
//  StationTarget.swift
//  CommuteFriend
//
//  Created by 박태현 on 2023/10/16.
//

import Foundation

protocol StationTarget: Hashable {
    var id: String { get }
    var latPos: Double { get }
    var lonPos: Double { get }
}

enum StationTargetType: Hashable {
    case subway(target: SubwayTarget)
    case bus(target: BusTarget)

    var id: String {
        switch self {
        case .bus(let target):
            return target.id
        case .subway(let target):
            return target.id
        }
    }
}
