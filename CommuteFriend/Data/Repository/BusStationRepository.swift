//
//  BusStationRepository.swift
//  CommuteFriend
//
//  Created by 박태현 on 2023/10/17.
//

import Foundation

final class BusStationRepository {

    private let networkManager: NetworkService

    init(networkManager: NetworkService) {
        self.networkManager = networkManager
    }

}

extension BusStationRepository {

    func fetchStationByRoute(
        routeID: String,
        completion: @escaping (Result<[BusStation], NetworkError>) -> Void
    ) {
        networkManager.request(
            type: BusStationByRouteResponseDTO.self,
            api: .busStationByRoute(query: routeID)
        ) { result in
            let mappedResult = result.map {
                return $0.msgBody.itemList?.map { $0.toDomain() } ?? []
            }
            completion(mappedResult)
        }
    }

}
