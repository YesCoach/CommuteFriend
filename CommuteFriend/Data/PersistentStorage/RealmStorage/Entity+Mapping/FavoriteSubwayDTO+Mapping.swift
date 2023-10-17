//
//  FavoriteSubwayDTO+Mapping.swift
//  CommuteFriend
//
//  Created by 박태현 on 2023/10/16.
//

import Foundation
import RealmSwift

class FavoriteSubwayDTO: Object, RealmMapping {
    typealias DomainType = FavoriteItem

    @Persisted(primaryKey: true) var id: String

    @Persisted var subwayName: String
    @Persisted var subwayLineNumber: String
    @Persisted var subwayUpDownDirection: String
    @Persisted var subwayDestinationName: String
    @Persisted var isAlarm: Bool

    convenience init(favoriteItem: DomainType) {
        self.init()
        self.id = favoriteItem.id

        switch favoriteItem.stationTarget {
        case .subway(let target):
            self.subwayName = target.name
            self.subwayLineNumber = target.lineNumber.rawValue
            self.subwayUpDownDirection = target.upDownDirection.rawValue
            self.subwayDestinationName = target.destinationName
        default:
            return
        }

        self.isAlarm = favoriteItem.isAlarm
    }

    func toDomain() -> DomainType {
        return DomainType(
            id: id,
            stationTarget: .subway(
                target: .init(
                    name: subwayName,
                    lineNumber: SubwayLine(rawValue: subwayLineNumber) ?? .number1,
                    destinationName: subwayDestinationName,
                    upDownDirection: UpDownDirection(rawValue: subwayUpDownDirection) ?? .up
                )
            ),
            isAlarm: isAlarm
        )
    }
}
