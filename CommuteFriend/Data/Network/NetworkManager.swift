//
//  NetworkManager.swift
//  CommuteFriend
//
//  Created by 박태현 on 2023/10/11.
//

import Foundation
import Alamofire

protocol NetworkService {
    func request<T: Decodable>(
        type: T.Type,
        api: Router,
        completion: @escaping (Result<T, NetworkError>) -> Void
    )
}

final class NetworkManager: NetworkService {

    static let shared = NetworkManager()

    private init() { }

}

extension NetworkManager {

    func request<T: Decodable>(
        type: T.Type,
        api: Router,
        completion: @escaping (Result<T, NetworkError>) -> Void
    ) {

        // Alamofire에서 내부적으로 asURLRequest 호출해줌(프로토콜))
        AF.request(api)
            .responseDecodable(of: T.self) { response in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    dump(error)
                    let networkError = NetworkError(rawValue: response.response?.statusCode ?? 0)
                    completion(.failure(networkError ?? .unknownError))
                }
            }
    }

}
