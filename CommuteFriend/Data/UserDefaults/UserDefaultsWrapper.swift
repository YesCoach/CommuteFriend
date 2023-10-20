//
//  UserDefaultsWrapper.swift
//  CommuteFriend
//
//  Created by 박태현 on 2023/10/20.
//

import Foundation

@propertyWrapper
struct UserDefault<T> {

    let key: String
    let defaultValue: T

    var wrappedValue: T {
        get { UserDefaults.standard.object(forKey: key) as? T ?? self.defaultValue }
        set { UserDefaults.standard.set(newValue, forKey: self.key) }
    }
}
