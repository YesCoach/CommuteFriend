//
//  LocalSubwayRepository.swift
//  CommuteFriend
//
//  Created by 박태현 on 2023/10/12.
//

import Foundation

final class LocalSubwayRepository {

    typealias FavoriteItemType = FavoriteItem<SubwayTarget>

    // MARK: - Dependency

    private let subwayStationStorage: SubwayStationStorage

    private var stationList: [SubwayStation]?
    var stationDictionary: [String: SubwayStation] = [:]

    // MARK: - DI

    init(
        subwayStationStorage: SubwayStationStorage
    ) {
        self.subwayStationStorage = subwayStationStorage
        configureJSONData()
        configureDictionaryData()
    }

    // MARK: - Methods

    // MARK: - Search

    /// 로컬 JSON으로 부터 지하철 역을 검색합니다.
    /// - Parameter name: 검색할 지하철 이름
    /// - Returns: 검색 결과에 해당하는 지하철 역 타입 배열
    func fetchStationByName(name: String) -> [SubwayStation]? {
        guard let stationList else { return nil }
        let filteringList = stationList
            .filter { $0.name.contains(name) }
            .sorted { $0.lineNumber.rawValue < $1.lineNumber.rawValue }

        return Set(filteringList).count != 0 ? filteringList : nil
    }

    /// 지하철 타깃 정보를 렘에 저장합니다.
    /// - Parameter subwayTarget: 실시간 도착 정보를 요청할 수 있는 SubwayTarget 타입
    func enrollStation(subwayTarget: SubwayTarget) {
        let subwayEntity = SubwayEntity(target: subwayTarget)
        subwayStationStorage.enrollStation(station: subwayEntity)
    }

    /// 저장되어 있는 지하철 타깃 정보 배열을 반환합니다.
    /// - Returns: 실시간 도착 정보를 요청할 수 있는 SubwayTarget 타입 배열
    func fetchEnrolledStationList() -> [SubwayTarget] {
        return subwayStationStorage.readStationList().map { $0.toDomain() }
    }

    /// 저장되어 있는 지하철 타깃을 삭제합니다.
    /// - Parameter station: 삭제할 지하철 타깃 타입
    func removeStation(station: SubwayTarget) {
        let subwayEntity = SubwayEntity(target: station)
        subwayStationStorage.deleteStation(station: subwayEntity)
    }

    // MARK: - Favorite

    func enrollFavoriteStation(item: FavoriteItemType) throws {
        let favoriteItemDTO = FavoriteSubwayDTO(favoriteItem: item)
        try subwayStationStorage.enrollFavoriteSubway(favorite: favoriteItemDTO)
    }

    func readFavoriteStationList() -> [FavoriteItemType] {
        subwayStationStorage.readFavoriteSubway().map { $0.toDomain() }
    }

    func deleteFavoriteStation(item: FavoriteItemType) {
        let favoriteItemDTO = FavoriteSubwayDTO(favoriteItem: item)
        subwayStationStorage.deleteFavoriteSubway(favorite: favoriteItemDTO)
    }

    func updateFavoriteStationList(item: FavoriteItemType) {
        let favoriteItemDTO = FavoriteSubwayDTO(favoriteItem: item)
        subwayStationStorage.updateFavoriteSubway(favorite: favoriteItemDTO)
    }

}

// MARK: - Private methods

private extension LocalSubwayRepository {

    func configureJSONData() {
        guard let path = Bundle.main.path(forResource: "SubwayStationInformation", ofType: "json"),
              let jsonString = try? String(contentsOfFile: path)
        else { return }

        let decoder = JSONDecoder()
        let data = jsonString.data(using: .utf8)
        if let data = data {
            do {
                let subwayStationList = try decoder.decode(SubwayStationList.self, from: data)
                self.stationList = subwayStationList.map { $0.toDomain() }
            } catch {
                print(error)
            }
        }
    }

    func configureDictionaryData() {
        guard let stationList else { return }
        stationList.forEach { stationDictionary[$0.code] = $0 }
    }

}
