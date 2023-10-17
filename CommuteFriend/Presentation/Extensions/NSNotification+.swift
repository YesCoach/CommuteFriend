//
//  NSNotification+.swift
//  CommuteFriend
//
//  Created by 박태현 on 2023/10/15.
//

import Foundation

extension NSNotification.Name {

    static let homeUpdateNotification: Self = NSNotification.Name(
        Constants.NotificationName.homeUpdateNotification
    )

    static let addStationArrivalTarget: Self = NSNotification.Name(
        Constants.NotificationName.addStationArrivalTarget
    )

    static let favoriteUpdateNotification: Self = NSNotification.Name(
        Constants.NotificationName.favoriteUpdateNotification
    )

    static let busHomeUpdateNotification: Self = NSNotification.Name(
        Constants.NotificationName.busHomeUpdateNotification
    )

}
