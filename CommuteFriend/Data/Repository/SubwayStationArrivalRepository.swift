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
        with stationTarget: SubwayTarget,
        completion: @escaping (Result<[SubwayArrival], NetworkError>) -> Void
    ) {
        networkManager.request(
            type: SubwayStationArrivalResponseDTO.self,
            api: .subwayStationArrivalInfo(query: stationTarget.name)
        ) { result in
            switch result {
            case .success(let data):
                let arrivalList = data
                    .toDomain()
                    .filter {
                        $0.subwayLine == stationTarget.lineNumber &&
                        $0.nextStation == stationTarget.destinationName
                    }
                    .sorted { $0.ordkey < $1.ordkey }
                if arrivalList.count >= 2 {
                    completion(.success(Array(arrivalList[0..<2])))
                }
                completion(.success(arrivalList))
            case .failure(let error):
                debugPrint(error)
                completion(.failure(error))
                return
            }
        }
    }

}
