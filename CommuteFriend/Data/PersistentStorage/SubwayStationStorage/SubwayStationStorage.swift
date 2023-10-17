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

    // MARK: - Favorite
    func enrollFavoriteSubway(favorite: FavoriteSubwayDTO) throws
    func readFavoriteSubway() -> [FavoriteSubwayDTO]
    func deleteFavoriteSubway(favorite: FavoriteSubwayDTO)
    func updateFavoriteSubway(favorite: FavoriteSubwayDTO)
}
