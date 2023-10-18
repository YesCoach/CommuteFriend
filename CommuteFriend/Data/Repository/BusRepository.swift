//
//  BusRepository.swift
//  CommuteFriend
//
//  Created by 박태현 on 2023/10/17.
//

import Foundation

final class BusRepository {

    private let networkManager: NetworkService

    init(networkManager: NetworkService) {
        self.networkManager = networkManager
    }
}

extension BusRepository {

    func fetch(
        keyword: String,
        completion: @escaping (Result<[Bus], NetworkError>) -> Void
    ) {
        networkManager.request(
            type: BusResponseDTO.self,
            api: .busInfo(query: keyword)
        ) { result in
            let mappedResult = result
                .map {
                    $0.msgBody.itemList?.map { $0.toDomain() } ?? []
                }
            completion(mappedResult)
        }
    }

    func fetchByStation(
        station: BusStation,
        completion: @escaping (Result<[Bus], NetworkError>) -> Void
    ) {
        networkManager.request(
            type: BusRouteByStationResponseDTO.self,
            api: .busRouteByStation(query: station.arsID)
        ) { result in
            let mappedResult = result
                .map { $0.msgBody.itemList?.map { $0.toDomain() } ?? [] }
            completion(mappedResult)
        }
    }

}
