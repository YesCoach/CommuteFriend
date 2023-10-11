//
//  TabBarItems.swift
//  CommuteFriend
//
//  Created by 박태현 on 2023/10/11.
//

import UIKit

enum TabBarItems {
    case home
    case favorite

    var tabBarItem: UITabBarItem {
        switch self {
        case .home:
            return UITabBarItem(title: "홈", image: .init(systemName: "house.fill"), tag: 0)
        case .favorite:
            return UITabBarItem(title: "즐겨찾기", image: .init(systemName: "star.fill"), tag: 1)
        }
    }
}
