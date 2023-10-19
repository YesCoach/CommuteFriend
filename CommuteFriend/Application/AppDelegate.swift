//
//  AppDelegate.swift
//  CommuteFriend
//
//  Created by 박태현 on 2023/10/11.
//

import UIKit
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    let notificationCenter = UNUserNotificationCenter.current()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        let userStorage = DIContainer.shared.userStorage
        if userStorage.isUserEntityExist() == false {
            userStorage.createUserEntity()
        }
        RealmStorage.shared.checkSchemaVersion()

        // MARK: - Location 관련 로직
        LocationManager.shared.requestAuthorization()

        // MARK: - Notification 관련 로직
        setupUserNotificationCenter()

        return true
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

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {

        return completionHandler(UNNotificationPresentationOptions.banner)
    }

    func setupUserNotificationCenter() {

        notificationCenter.delegate = self

        notificationCenter.requestAuthorization(options: [.alert]) { granted, error in
            if (error != nil) {
                print("Notification Authorization Error: " + error!.localizedDescription)
            }else{
                print("Notification Authorization Granted: " + granted.description)
            }
        }
    }
}
