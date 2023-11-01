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
    @Persisted var recentBusList: List<BusDTO>
    @Persisted var favoriteBusList: List<FavoriteBusDTO>

    convenience init(
        recentSubwayList: [SubwayEntity],
        favoriteSubwayList: [FavoriteSubwayDTO],
        recentBusList: [BusDTO],
        favoriteBusList: [FavoriteBusDTO]
    ) {
        self.init()
        self.id = UserEntity.id
        self.recentSubwayList.append(objectsIn: recentSubwayList)
        self.favoriteSubwayList.append(objectsIn: favoriteSubwayList)
        self.recentBusList.append(objectsIn: recentBusList)
        self.favoriteBusList.append(objectsIn: favoriteBusList)
    }
}
