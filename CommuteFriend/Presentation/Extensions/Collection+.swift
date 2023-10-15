//
//  Collection+.swift
//  CommuteFriend
//
//  Created by 박태현 on 2023/10/15.
//

import Foundation

extension Collection {

    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }

}
