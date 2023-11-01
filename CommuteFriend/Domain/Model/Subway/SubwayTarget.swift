//
//  SubwayTarget.swift
//  CommuteFriend
//
//  Created by 박태현 on 2023/10/15.
//

import Foundation

struct SubwayTarget: StationTarget {
    let id: String
    let name: String
    let lineNumber: SubwayLine
    let destinationName: String
    var upDownDirection: UpDownDirection
    let latPos: Double
    let lonPos: Double

    init(
        id: String = UUID().uuidString,
        name: String,
        lineNumber: SubwayLine,
        destinationName: String,
        upDownDirection: UpDownDirection,
        latPos: Double,
        lonPos: Double
    ) {
        self.id = id
        self.name = name
        self.lineNumber = lineNumber
        self.destinationName = destinationName
        self.upDownDirection = upDownDirection
        self.latPos = latPos
        self.lonPos = lonPos
    }
}
