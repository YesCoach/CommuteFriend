//
//  LocalBusRepository.swift
//  CommuteFriend
//
//  Created by 박태현 on 2023/10/12.
//

import Foundation

final class LocalBusRepository {

    static let shared = LocalBusRepository()

    var busStationList: BusStationList?

    init() {
        configureJSONData()
    }

    private func configureJSONData() {
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

    func fetchStationByName(name: String) -> [BusStation]? {
        guard let busStationList else { return nil }
        let filteringList = busStationList.data
            .filter { $0.sttnNm.contains(name) }
            .map { $0.toDomain() }
            .sorted { $0.name < $1.name }

        return Set(filteringList).count != 0 ? filteringList : nil
    }

}
