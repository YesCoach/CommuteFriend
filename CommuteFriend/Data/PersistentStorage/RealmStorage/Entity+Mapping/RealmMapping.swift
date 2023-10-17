//
//  RealmMapping.swift
//  CommuteFriend
//
//  Created by 박태현 on 2023/10/15.
//

import Foundation

protocol RealmMapping {
    associatedtype DomainType

    func toDomain() -> DomainType
}
