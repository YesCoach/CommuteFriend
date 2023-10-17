//
//  Bus.swift
//  CommuteMate
//
//  Created by 박태현 on 2023/09/30.
//

import Foundation

struct Bus: BusSearchable {
    let id: String
    let kind: BusType
    let name: String
    let direction: String
}
