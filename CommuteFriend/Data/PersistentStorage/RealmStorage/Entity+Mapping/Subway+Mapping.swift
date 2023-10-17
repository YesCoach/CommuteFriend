//
//  Subway+Mapping.swift
//  CommuteFriend
//
//  Created by 박태현 on 2023/10/15.
//

import Foundation
import RealmSwift

class SubwayEntity: Object, RealmMapping {
    typealias DomainType = SubwayTarget

    @Persisted(primaryKey: true) var id: String

    @Persisted var subwayName: String
    @Persisted var subwayLineNumber: String
    @Persisted var subwayUpDownDirection: String
    @Persisted var subwayDestinationName: String

    convenience init(target: SubwayTarget) {
        self.init()
        self.id = target.id
        self.subwayName = target.name
        self.subwayLineNumber = target.lineNumber.rawValue
        self.subwayUpDownDirection = target.upDownDirection.rawValue
        self.subwayDestinationName = target.destinationName
    }

    func toDomain() -> DomainType {
        return SubwayTarget(
            id: id,
            name: subwayName,
            lineNumber: SubwayLine(rawValue: subwayLineNumber) ?? .number1,
            destinationName: subwayDestinationName,
            upDownDirection: UpDownDirection(rawValue: subwayUpDownDirection) ?? .up
        )
    }
}
