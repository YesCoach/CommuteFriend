//
//  DTOMapping.swift
//  CommuteMate
//
//  Created by 박태현 on 2023/09/27.
//

import Foundation

protocol DTOMapping: Decodable {
    associatedtype DomainType

    func toDomain() -> DomainType
}
