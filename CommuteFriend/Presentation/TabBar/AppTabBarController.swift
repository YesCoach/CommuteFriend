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

    var homeViewController = DIContainer.shared.makeHomeViewController()
    var busHomeViewController = DIContainer.shared.makeBusHomeViewController()
    // TODO: - 설정 탭 추가
//    var settingViewController = SettingViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        setTabBarController()
        enrollNotification()
    }

    private func setTabBarController() {
        homeViewController.tabBarItem = TabBarItems.home.tabBarItem
        subwayDelegate = homeViewController

        busHomeViewController.tabBarItem = TabBarItems.bus.tabBarItem
        busDelegate = busHomeViewController

        tabBar.tintColor = .black

        self.viewControllers = [
            UINavigationController(rootViewController: homeViewController),
            UINavigationController(rootViewController: busHomeViewController)
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
        guard let itemType = notification.userInfo?["itemType"] as? String,
              let identifier = notification.userInfo?["identifier"] as? String
        else { return }

        if itemType == "subway" {
            selectedIndex = 0
            homeViewController.dismiss(animated: true)
            if let vc = selectedViewController as? UINavigationController {
                vc.popToRootViewController(animated: true)
            }
            subwayDelegate?.updatePriorityStationTarget(stationTargetID: identifier)
        } else {
            selectedIndex = 1
            busHomeViewController.dismiss(animated: true)
            if let vc = selectedViewController as? UINavigationController {
                vc.popToRootViewController(animated: true)
            }
            busDelegate?.updatePriorityStationTarget(stationTargetID: identifier)
        }

    }
}
