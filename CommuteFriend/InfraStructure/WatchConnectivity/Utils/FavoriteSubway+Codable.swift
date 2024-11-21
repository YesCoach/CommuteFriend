//
//  FavoriteSubwayCodable.swift
//  CommuteFriend
//
//  Created by 박태현 on 11/22/24.
//

struct FavoriteSubwayCodable: Codable {
    let id: String
    let subwayName: String
    let subwayLineNumber: String
    let subwayUpDownDirection: String
    let subwayDestinationName: String
    let subwayLatitude: Double
    let subwayLongitude: Double
    let isAlarm: Bool

    init?(favoriteItem: FavoriteItem) {
        self.id = favoriteItem.id
        self.isAlarm = favoriteItem.isAlarm

        switch favoriteItem.stationTarget {
        case .subway(let target):
            self.subwayName = target.name
            self.subwayLineNumber = target.lineNumber.rawValue
            self.subwayUpDownDirection = target.upDownDirection.rawValue
            self.subwayDestinationName = target.destinationName
            self.subwayLatitude = target.latPos
            self.subwayLongitude = target.lonPos
        default: return nil
        }
    }

    func toDomain() -> FavoriteItem {
        let target = SubwayTarget(
            id: id,
            name: subwayName,
            lineNumber: SubwayLine(rawValue: subwayLineNumber) ?? .number1,
            destinationName: subwayDestinationName,
            upDownDirection: UpDownDirection(rawValue: subwayUpDownDirection) ?? .up,
            latPos: subwayLatitude,
            lonPos: subwayLongitude
        )
        return FavoriteItem(stationTarget: .subway(target: target), isAlarm: isAlarm)
    }
}
