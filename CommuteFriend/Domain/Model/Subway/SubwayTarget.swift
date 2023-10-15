//
//  SubwayTarget.swift
//  CommuteFriend
//
//  Created by 박태현 on 2023/10/15.
//

import Foundation

struct SubwayTarget: Hashable {
    let id: String
    let name: String
    let lineNumber: SubwayLine
    let destinationName: String
    var upDownDirection: UpDownDirection

    init(
        id: String = UUID().uuidString,
        name: String,
        lineNumber: SubwayLine,
        destinationName: String,
        upDownDirection: UpDownDirection
    ) {
        self.id = id
        self.name = name
        self.lineNumber = lineNumber
        self.destinationName = destinationName
        self.upDownDirection = upDownDirection
    }
}
