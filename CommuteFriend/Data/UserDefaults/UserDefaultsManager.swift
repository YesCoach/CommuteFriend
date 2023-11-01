//
//  UserDefaultsManager.swift
//  CommuteFriend
//
//  Created by 박태현 on 2023/10/20.
//

import Foundation

enum UserDefaultsKey: String, CaseIterable {

    case notificationItemType
    case notificationItemIdentifier

}

final class UserDefaultsManager {

    @UserDefault(key: UserDefaultsKey.notificationItemType.rawValue, defaultValue: nil)
    static var notificationItemType: String?

    @UserDefault(key: UserDefaultsKey.notificationItemIdentifier.rawValue, defaultValue: nil)
    static var notificationItemIdentifier: String?

    static func removeAllValue() {
        UserDefaultsKey.allCases.forEach {
            UserDefaults.standard.removeObject(forKey: $0.rawValue)
        }
    }
}
