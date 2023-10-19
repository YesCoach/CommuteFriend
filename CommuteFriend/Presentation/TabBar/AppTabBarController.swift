//
//  AppTabBarController.swift
//  CommuteFriend
//
//  Created by 박태현 on 2023/10/11.
//

import UIKit

protocol NotificationTriggerDelegate: AnyObject {
    func updatePriorityStationTarget(stationTargetID: String)
}

final class AppTabBarController: UITabBarController {

    weak var subwayDelegate: NotificationTriggerDelegate?
    weak var busDelegate: NotificationTriggerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        setTabBarController()
        enrollNotification()
    }

    private func setTabBarController() {
        let homeViewController = DIContainer.shared.makeHomeViewController()
        homeViewController.tabBarItem = TabBarItems.home.tabBarItem
        subwayDelegate = homeViewController

        let busHomeViewController = DIContainer.shared.makeBusHomeViewController()
        busHomeViewController.tabBarItem = TabBarItems.bus.tabBarItem
        busDelegate = busHomeViewController

        let favoriteViewController = UIViewController()
        favoriteViewController.view.backgroundColor = .systemOrange
        favoriteViewController.tabBarItem = TabBarItems.favorite.tabBarItem

        tabBar.tintColor = .label

        self.viewControllers = [
            UINavigationController(rootViewController: homeViewController),
            UINavigationController(rootViewController: busHomeViewController),
            favoriteViewController
        ]
    }

    private func enrollNotification() {
        // 푸시 알림으로 앱 실행시 노티피케이션 전달받을 옵저버
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(userNotificationTriggered),
            name: .userNotificationTriggerNotification,
            object: nil
        )
    }

    @objc func userNotificationTriggered(notification: Notification) {
        guard let index = notification.userInfo?["index"] as? Int,
              let identifier = notification.userInfo?["identifier"] as? String
        else { return }
        selectedIndex = index
        if index == 0 {
            subwayDelegate?.updatePriorityStationTarget(stationTargetID: identifier)
        } else {
            busDelegate?.updatePriorityStationTarget(stationTargetID: identifier)
        }
    }
}
