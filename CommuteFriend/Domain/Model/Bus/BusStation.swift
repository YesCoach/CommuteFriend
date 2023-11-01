//
//  BusStation.swift
//  CommuteMate
//
//  Created by 박태현 on 2023/09/30.
//

import Foundation

struct BusStation: BusSearchable {
    let id: String
    let name: String
    /// 정류장 식별용 ID(API에서도 이거로 사용)
    let arsID: String
    /// 정류장 방면(@@방면)
    let direction: String
    let latPos: Double
    let lonPos: Double

    var routeList: [String]?
}
