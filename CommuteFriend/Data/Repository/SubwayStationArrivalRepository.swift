//
//  SubwayStationArrivalRepository.swift
//  CommuteFriend
//
//  Created by 박태현 on 2023/10/15.
//

import Foundation

final class SubwayStationArrivalRepository {

    private let networkManager: NetworkService

    init(networkManager: NetworkService) {
        self.networkManager = networkManager
    }

}

extension SubwayStationArrivalRepository {

    func fetchSubwayStationArrival(
        with stationTarget: SubwayTarget
    ) async throws -> [SubwayArrival] {
        let arrivalList = try await networkManager.request(
            type: SubwayStationArrivalResponseDTO.self,
            api: .subwayStationArrivalInfo(query: stationTarget.name)
        )
        .toDomain()
        .filter {
            $0.subwayLine == stationTarget.lineNumber &&
            $0.nextStation == stationTarget.destinationName
        }
        .sorted { $0.ordkey < $1.ordkey }

        if arrivalList.count >= 2 {
            return Array(arrivalList[0..<2])
        } else {
            return arrivalList
        }
    }

}
