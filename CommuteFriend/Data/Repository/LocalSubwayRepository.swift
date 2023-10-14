//
//  LocalSubwayRepository.swift
//  CommuteFriend
//
//  Created by 박태현 on 2023/10/12.
//

import Foundation

final class LocalSubwayRepository {

    static let shared = LocalSubwayRepository()

    private var stationList: [SubwayStation]?
    var stationDictionary: [String: SubwayStation] = [:]

    init() {
        configureJSONData()
        configureDictionaryData()
    }

    func fetchStationByName(name: String) -> [SubwayStation]? {
        guard let stationList else { return nil }
        let filteringList = stationList
            .filter { $0.name.contains(name) }
            .sorted { $0.lineNumber.rawValue < $1.lineNumber.rawValue }

        return Set(filteringList).count != 0 ? filteringList : nil
    }

}

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
