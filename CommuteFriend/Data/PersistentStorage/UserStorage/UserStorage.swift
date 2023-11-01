//
//  UserStorage.swift
//  CommuteFriend
//
//  Created by 박태현 on 2023/10/15.
//

import Foundation

final class UserStorage {

    private let realmStorage: RealmStorage

    init(realmStorage: RealmStorage) {
        self.realmStorage = realmStorage
    }

    func createUserEntity() {
        realmStorage.createData(data: UserEntity())
    }

    func isUserEntityExist() -> Bool {
        guard let result = try? realmStorage.readData(UserEntity.self) else { return false }
        return !result.isEmpty
    }
}
