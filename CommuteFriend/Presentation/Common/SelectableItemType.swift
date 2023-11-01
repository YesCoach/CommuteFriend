//
//  SelectableItemType.swift
//  CommuteFriend
//
//  Created by 박태현 on 2023/10/11.
//

import Foundation

protocol SelectableType {
    var description: String { get }
    var imageName: String { get }
}

extension TransportationType: SelectableType { }
