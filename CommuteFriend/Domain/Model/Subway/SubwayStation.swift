//
//  SubwayStation.swift
//  CommuteMate
//
//  Created by 박태현 on 2023/09/26.
//

import Foundation

struct SubwayStation: Hashable {
    private let uuid = UUID().uuidString
    let name: String
    let lineNumber: SubwayLine
    var upDownDirection: UpDownDirection?
}
