//
//  LocalSubwayRepository.swift
//  CommuteFriend
//
//  Created by 박태현 on 2023/10/12.
//

import Foundation

final class LocalSubwayRepository {

    static let shared = LocalSubwayRepository()
    var stationList: SubwayStationList?

    init() {
        configureJSONData()
    }

    private func configureJSONData() {
        guard let path = Bundle.main.path(forResource: "SubwayStationInformation", ofType: "json"),
              let jsonString = try? String(contentsOfFile: path)
        else { return }

        let decoder = JSONDecoder()
        let data = jsonString.data(using: .utf8)
        if let data = data,
           let subwayStationList = try? decoder.decode(SubwayStationList.self, from: data) {
            self.stationList = subwayStationList
        }
    }

    func fetchStationByName(name: String) -> [SubwayStation]? {
        guard let stationList else { return nil }
        let filteringList = stationList
            .filter { $0.statnNm.contains(name) }
            .map { $0.toDomain() }
            .sorted { $0.lineNumber.rawValue < $1.lineNumber.rawValue }

        return Set(filteringList).count != 0 ? filteringList : nil
    }

}
