//
//  StationStorage.swift
//  CommuteFriend
//
//  Created by 박태현 on 2023/10/15.
//

import Foundation

protocol SubwayStationStorage {
    func enrollStation(station: SubwayEntity)
    func readStation() -> SubwayEntity?
    func readStationList() -> [SubwayEntity]
    func deleteStation(station: SubwayEntity)
}
