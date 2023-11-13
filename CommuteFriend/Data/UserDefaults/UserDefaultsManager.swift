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
    case isAppUpToDate

}

final class UserDefaultsManager {

    @UserDefault(key: UserDefaultsKey.notificationItemType.rawValue, defaultValue: nil)
    static var notificationItemType: String?

    @UserDefault(key: UserDefaultsKey.notificationItemIdentifier.rawValue, defaultValue: nil)
    static var notificationItemIdentifier: String?

    @UserDefault(key: UserDefaultsKey.isAppUpToDate.rawValue, defaultValue: true)
    static var isAppUpToDate: Bool

    static func removeAllValue() {
        UserDefaultsKey.allCases.forEach {
            UserDefaults.standard.removeObject(forKey: $0.rawValue)
        }
    }
}
