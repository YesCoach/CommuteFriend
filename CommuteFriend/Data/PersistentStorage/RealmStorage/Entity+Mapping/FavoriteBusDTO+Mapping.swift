//
//  FavoriteBusDTO.swift
//  CommuteFriend
//
//  Created by 박태현 on 2023/10/17.
//

import Foundation
import RealmSwift

class FavoriteBusDTO: Object, RealmMapping {
    typealias DomainType = FavoriteItem

    @Persisted(primaryKey: true) var id: String

    @Persisted var stationID: String
    @Persisted var stationName: String
    @Persisted var busDirection: String
    @Persisted var busRouteID: String
    @Persisted var busRouteName: String
    @Persisted var stationLat: Double
    @Persisted var stationLon: Double

    @Persisted var isAlarm: Bool

    convenience init(favoriteItem: DomainType) {
        self.init()
        self.id = favoriteItem.id

        switch favoriteItem.stationTarget {
        case .bus(let target):
            self.stationID = target.stationID
            self.stationName = target.stationName
            self.busDirection = target.direction
            self.busRouteID = target.busRouteID ?? ""
            self.busRouteName = target.busRouteName ?? ""
            self.stationLat = target.latPos
            self.stationLon = target.lonPos
        default:
            return
        }

        self.isAlarm = favoriteItem.isAlarm
    }

    func toDomain() -> DomainType {
        return DomainType(
            stationTarget: .bus(
                target: .init(
                    id: id,
                    stationID: stationID,
                    stationName: stationName,
                    direction: busDirection,
                    busRouteID: busRouteID,
                    busRouteName: busRouteName,
                    latPos: stationLat,
                    lonPos: stationLon
                )
            ),
            isAlarm: isAlarm
        )
    }
}
