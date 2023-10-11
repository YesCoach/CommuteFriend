//
//  SubwayRepository.swift
//  CommuteFriend
//
//  Created by 박태현 on 2023/10/12.
//

import Foundation

final class SubwayRepository {

    private let networkManager: NetworkService

    init(networkManager: NetworkService) {
        self.networkManager = networkManager
    }

}

extension SubwayRepository {

    func fetchStationByName(
        name: String,
        completion: @escaping (Result<[SubwayStation], NetworkError>) -> Void
    ) {
        networkManager.request(
            type: SubwayStationResponseDTO.self,
            api: .subwayStationInfo(query: name)
        ) { result in
            let mappedResult = result.map { $0.toDomain() }
            completion(mappedResult)
        }
    }

}
