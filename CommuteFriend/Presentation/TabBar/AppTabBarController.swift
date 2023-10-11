//
//  AppTabBarController.swift
//  CommuteFriend
//
//  Created by 박태현 on 2023/10/11.
//

import UIKit

final class AppTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setTabBarController()
    }

    private func setTabBarController() {
        let homeViewController = UIViewController()
        homeViewController.view.backgroundColor = .systemRed
        homeViewController.tabBarItem = TabBarItems.home.tabBarItem

        let favoriteViewController = UIViewController()
        favoriteViewController.view.backgroundColor = .systemOrange
        favoriteViewController.tabBarItem = TabBarItems.favorite.tabBarItem

        tabBar.tintColor = .label

        self.viewControllers = [homeViewController, favoriteViewController]
    }

}
