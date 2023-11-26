//
//  AppDelegate.swift
//  CommuteFriend
//
//  Created by 박태현 on 2023/10/11.
//

import UIKit
import UserNotifications
import FirebaseCore

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    let notificationCenter = UNUserNotificationCenter.current()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        // MARK: Firebase 관련 설정
        FirebaseApp.configure()

        let userStorage = DIContainer.shared.userStorage
        if userStorage.isUserEntityExist() == false {
            userStorage.createUserEntity()
        }
        RealmStorage.shared.checkSchemaVersion()

        // MARK: App 버전 체크
        VersionCheckManager.shared.isAppVersionUpToDate { result in
            switch result {
            case .success(let isAppUpToDate):
                UserDefaultsManager.isAppUpToDate = isAppUpToDate
            case .failure(let error):
                debugPrint(error)
            }
        }

        // MARK: Location 관련 로직
        LocationManager.shared.requestAuthorization()

        // MARK: Notification 관련 로직
        setupUserNotificationCenter()

        // MARK: Dynamic Island 관련 로직
        ArrivalWidgetManager.shared.stop()

        // MARK: Network 체크
        NetworkCheckManager.shared.startMonitoring()

        sleep(2)

        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        NetworkCheckManager.shared.stopMonitoring()
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

// MARK: - UNUserNotificationCenterDelegate

extension AppDelegate {

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        return completionHandler([.banner, .sound])
    }

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        let notificationIdentifier = response.notification.request.identifier
        let notificationUserInfo = response.notification.request.content.userInfo

        // 1. 노티피케이션을 포스트
        // 2. 탭바에서 노티피케이션을 옵저빙 -> 지하철, 버스에 맞게 탭 이동
        // 3. 이동했을때 해당 노티피케이션의 타깃 아이템을 홈 화면에 보여줘야함

        UserDefaultsManager.notificationItemIdentifier = notificationIdentifier
        if let value = notificationUserInfo["itemType"] as? String {
            UserDefaultsManager.notificationItemType = value
        }

    }

    func setupUserNotificationCenter() {
        notificationCenter.delegate = self
        notificationCenter.requestAuthorization(options: [.alert, .sound]) { granted, error in
            if (error != nil) {
                print("Notification Authorization Error: " + error!.localizedDescription)
            } else {
                print("Notification Authorization Granted: " + granted.description)
            }
        }
    }
}
