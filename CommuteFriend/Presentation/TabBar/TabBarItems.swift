//
//  TabBarItems.swift
//  CommuteFriend
//
//  Created by 박태현 on 2023/10/11.
//

import UIKit

enum TabBarItems {
    case home
    case bus
    case setting

    var tabBarItem: UITabBarItem {
        switch self {
        case .home:
            return UITabBarItem(title: "지하철", image: .init(systemName: "tram.fill"), tag: 0)
        case .bus:
            return UITabBarItem(title: "버스", image: .init(systemName: "bus.fill"), tag: 1)
        case .setting:
            return UITabBarItem(title: "설정", image: .init(systemName: "ellipsis"), tag: 2)
        }
    }
}
