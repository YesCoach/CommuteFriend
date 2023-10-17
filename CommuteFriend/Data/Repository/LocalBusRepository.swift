//
//  LocalBusRepository.swift
//  CommuteFriend
//
//  Created by 박태현 on 2023/10/12.
//

import Foundation

final class LocalBusRepository {

    // MARK: - Dependency

    private let busStationStorage: BusStationStorage

    var busStationList: BusStationList?

    // MARK: - DI

    init(
        busStationStorage: BusStationStorage
    ) {
        self.busStationStorage = busStationStorage
        configureJSONData()
    }

    // TODO: - Document 주석 추가하기

    func fetchStationByName(name: String) -> [BusStation]? {
        guard let busStationList else { return nil }
        let filteringList = busStationList.data
            .filter { $0.sttnNm.contains(name) }
            .map { $0.toDomain() }
            .sorted { $0.name < $1.name }

        return Set(filteringList).count != 0 ? filteringList : nil
    }

    func enrollStation(busTarget: BusTarget) {
        let busDTO = BusDTO(target: busTarget)
        busStationStorage.enrollStation(station: busDTO)
    }

    func fetchEnrolledStationList() -> [BusTarget] {
        return busStationStorage.readStationList().map { $0.toDomain() }
    }

    func removeStation(station: BusTarget) {
        let busDTO = BusDTO(target: station)
        busStationStorage.deleteStation(station: busDTO)
    }

    // MARK: - Favortie

    func enrollFavoriteStation(item: FavoriteItem) throws {
        let favoriteItemDTO = FavoriteBusDTO(favoriteItem: item)
        try busStationStorage.enrollFavoriteBus(favorite: favoriteItemDTO)
    }

    func readFavoriteStationList() -> [FavoriteItem] {
        busStationStorage.readFavoriteBus().map { $0.toDomain() }
    }

    func deleteFavoriteStation(item: FavoriteItem) {
        let favoriteItemDTO = FavoriteBusDTO(favoriteItem: item)
        busStationStorage.deleteFavoriteBus(favorite: favoriteItemDTO)
    }

    func updateFavoriteStationList(item: FavoriteItem) {
        let favoriteItemDTO = FavoriteBusDTO(favoriteItem: item)
        busStationStorage.updateFavoriteBus(favorite: favoriteItemDTO)
    }

}

private extension LocalBusRepository {

    func configureJSONData() {
        guard let path = Bundle.main.path(forResource: "BusStationInformation", ofType: "json"),
              let jsonString = try? String(contentsOfFile: path)
        else { return }

        let decoder = JSONDecoder()
        let data = jsonString.data(using: .utf8)
        if let data = data,
           let busStationList = try? decoder.decode(BusStationList.self, from: data) {
            self.busStationList = busStationList
        }
    }
}
