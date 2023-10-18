//
//  Constants.swift
//  CommuteFriend
//
//  Created by 박태현 on 2023/10/15.
//

import UIKit

enum Constants {

    enum NotificationName {

        // NotificationName

        static let homeUpdateNotification: String = "homeUpdateNotification"
        static let addStationArrivalTarget: String = "addStationArrivalTarget"
        static let favoriteUpdateNotification: String = "favoriteUpdateNotification"

        static let busHomeUpdateNotification: String = "busHomeUpdateNotification"

    }

    enum Policy {

        static let maximumStation: Int = 8
        static let favoriteMaximum: Int = 20

    }

}
