//
//  VersionCheckManager.swift
//  CommuteFriend
//
//  Created by 박태현 on 2023/11/11.
//

import Foundation
import Alamofire

// 오류 열거형 타입 enum 선언
enum VersionError: Error {
    case invalidResponse, invalidVersionInfo
}

final class VersionCheckManager {

    static let shared = VersionCheckManager()

    private init() { }

    func isAppVersionUpToDate(completion: @escaping (Result<Bool, Error>) -> Void) {

        let bundleVersion = Setting.currentAppBundleID()
        if bundleVersion.isEmpty { return }

        let appStoreURL = "https://itunes.apple.com/kr/lookup?bundleId=\(bundleVersion)"
        AF.request(appStoreURL).responseJSON { response in
            print(response.request?.url)
            switch response.result {
            case .success(let value):
                if let json = value as? [String: Any],
                   let results = json["results"] as? [[String: Any]],
                   let appStoreVersion = results.first?["version"] as? String {

                    if appStoreVersion > bundleVersion {
                        print("New version available on the App Store: \(appStoreVersion)")
                        completion(.success(false))
                    } else {
                        print("App is up to date.")
                        completion(.success(true))
                    }
                } else {
                    print("Unable to parse App Store response.")
                    completion(.failure(VersionError.invalidVersionInfo))
                }

            case .failure(let error):
                print("Error fetching App Store data: \(error)")
                completion(.failure(VersionError.invalidResponse))
            }
        }
    }

}
