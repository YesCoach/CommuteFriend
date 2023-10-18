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

enum StationTargetType {
    case subway(target: SubwayTarget)
    case bus(target: BusTarget)
}
