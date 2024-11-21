//
//  FavoriteBusCodable.swift
//  CommuteFriend
//
//  Created by 박태현 on 11/22/24.
//

struct FavoriteBusCodable: Codable {
    let id: String
    let stationID: String
    let stationName: String
    let busDirection: String
    let busRouteID: String
    let busRouteName: String
    let busType: String
    let stationLat: Double
    let stationLon: Double
    let isAlarm: Bool

    init?(favoriteItem: FavoriteItem) {
        self.id = favoriteItem.id
        self.isAlarm = favoriteItem.isAlarm

        switch favoriteItem.stationTarget {
        case .bus(let target):
            self.stationID = target.stationID
            self.stationName = target.stationName
            self.busDirection = target.direction
            self.busRouteID = target.busRouteID
            self.busRouteName = target.busRouteName
            self.busType = target.busType.rawValue
            self.stationLat = target.latPos
            self.stationLon = target.lonPos
        default: return nil
        }
    }

    func toDomain() -> FavoriteItem {
        let target = BusTarget(
            id: id,
            stationID: stationID,
            stationName: stationName,
            direction: busDirection,
            busRouteID: busRouteID,
            busRouteName: busRouteName,
            busType: BusType.init(rawValue: busType),
            latPos: stationLat,
            lonPos: stationLon
        )
        return FavoriteItem(stationTarget: .bus(target: target), isAlarm: isAlarm)
    }
}
