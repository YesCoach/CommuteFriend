//
//  BusStationStorage.swift
//  CommuteFriend
//
//  Created by 박태현 on 2023/10/17.
//

import Foundation

protocol BusStationStorage {
    func enrollStation(station: BusDTO)
    func readStationList() -> [BusDTO]
    func deleteStation(station: BusDTO)

    // MARK: - Favorite
    func enrollFavoriteBus(favorite: FavoriteBusDTO) throws
    func readFavoriteBus() -> [FavoriteBusDTO]
    func deleteFavoriteBus(favorite: FavoriteBusDTO)
    func updateFavoriteBus(favorite: FavoriteBusDTO)
}
