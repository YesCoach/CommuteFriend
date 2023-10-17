//
//  User+Mapping.swift
//  CommuteFriend
//
//  Created by 박태현 on 2023/10/15.
//

import Foundation
import RealmSwift

class UserEntity: Object {

    static let id = "UniqueID"

    @Persisted(primaryKey: true) var id: String

    @Persisted var recentSubwayList: List<SubwayEntity>
    @Persisted var favoriteSubwayList: List<FavoriteSubwayDTO>

    convenience init(
        recentSubwayList: [SubwayEntity],
        favoriteSubwayList: [FavoriteSubwayDTO]
    ) {
        self.init()
        self.id = UserEntity.id
        self.recentSubwayList.append(objectsIn: recentSubwayList)
        self.favoriteSubwayList.append(objectsIn: favoriteSubwayList)
    }
}
