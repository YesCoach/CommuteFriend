//
//  BusStationArrivalRepsitory.swift
//  CommuteFriend
//
//  Created by 박태현 on 2023/10/17.
//

import Foundation

final class BusStationArrivalRepsitory {

    private let networkManager: NetworkService

    init(networkManager: NetworkService) {
        self.networkManager = networkManager
    }

}

extension BusStationArrivalRepsitory {

    func fetchBusStationArrivalData(
        station: BusTarget,
        completion: @escaping (Result<[BusArrival], NetworkError>) -> Void
    ) {
        networkManager.request(
            type: BusStationArrivalResponseDTO.self,
            api: .busStationArrivalInfo(query: station.stationID)
        ) { result in
            let mappedResult = result.map { $0.toDomain() }
            completion(mappedResult)
        }
    }

}
