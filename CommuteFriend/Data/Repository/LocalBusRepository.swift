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
            .filter { $0.sttnNm.contains(name) && $0.sttnType != .ghost }
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
        busStationStorage.readFavoriteBusList().map { $0.toDomain() }
    }

    func readFavoriteStationTarget(with identifier: String) -> BusTarget? {
        if let item = busStationStorage.readFavoriteBus(identifier: identifier) {
            return .init(
                id: item.id,
                stationID: item.stationID,
                stationName: item.stationName,
                direction: item.busDirection,
                busRouteID: item.busRouteID,
                busRouteName: item.busRouteName,
                latPos: item.stationLat,
                lonPos: item.stationLon
            )
        }
        return nil
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
        guard let data = jsonString.data(using: .utf8) else {
            print("create data is failed")
            return
        }

        do {
            let busStationList = try decoder.decode(BusStationList.self, from: data)
            self.busStationList = busStationList
        } catch {
            debugPrint(error)
        }
    }
}
