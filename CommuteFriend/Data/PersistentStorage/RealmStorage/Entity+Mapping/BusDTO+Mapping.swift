//
//  BusDTO+Mapping.swift
//  CommuteFriend
//
//  Created by 박태현 on 2023/10/17.
//

import Foundation
import RealmSwift

class BusDTO: Object, RealmMapping {
    typealias DomainType = BusTarget

    @Persisted(primaryKey: true) var id: String

    @Persisted var stationID: String
    @Persisted var stationName: String
    @Persisted var busDirection: String
    @Persisted var busRouteID: String
    @Persisted var busRouteName: String

    convenience init(target: BusTarget) {
        self.init()
        self.id = target.id
        self.stationID = target.stationID
        self.stationName = target.stationName
        self.busDirection = target.direction
        self.busRouteID = target.busRouteID
        self.busRouteName = target.busRouteName
    }

    func toDomain() -> DomainType {
        return DomainType(
            id: id,
            stationID: stationID,
            stationName: stationName,
            direction: busDirection,
            busRouteID: busRouteID,
            busRouteName: busRouteName
        )
    }

}
