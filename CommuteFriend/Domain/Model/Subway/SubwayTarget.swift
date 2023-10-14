//
//  SubwayTarget.swift
//  CommuteFriend
//
//  Created by 박태현 on 2023/10/15.
//

import Foundation

struct SubwayTarget: Hashable {
    let name: String
    let lineNumber: SubwayLine
    let destinationName: String
    var upDownDirection: UpDownDirection
}
