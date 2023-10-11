//
//  UpDownDirection.swift
//  CommuteMate
//
//  Created by 박태현 on 2023/09/27.
//

import Foundation

enum UpDownDirection: String {
    case up = "상행"
    case down = "하행"

    var imageName: String {
        switch self {
        case .up: return "arrow.up.circle"
        case .down: return "arrow.down.circle"
        }
    }

    var description: String {
        switch self {
        case .up: return "상행"
        case .down: return "하행"
        }
    }
}
