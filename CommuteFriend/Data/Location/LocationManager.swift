//
//  LocationManager.swift
//  CommuteFriend
//
//  Created by 박태현 on 2023/10/18.
//

import CoreLocation
import UserNotifications

enum LocationManagerError: Error {
    case invalidLocation
}

final class LocationManager: NSObject {

    static let shared = LocationManager()

    private let locationManager = CLLocationManager()
    private var currentLocation: CLLocation?

    private override init() {
        super.init()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self

        // 백그라운드에서 위치 업데이트를 위한 설정
//        locationManager.allowsBackgroundLocationUpdates = true
        // 백그라운드에서 위치 서비스를 사용중임을 나타내기 위한 설정
        locationManager.showsBackgroundLocationIndicator = true
        locationManager.pausesLocationUpdatesAutomatically = false

        // TODO: - Turn off background updates when your app isn’t using them to save power.
        // 즐겨찾기에 등록된 정류장이 없으면 꺼주고, 하나라도 있으면 켜주기
    }

    /// 위치권한정보 메서드
    func requestAuthorization() {
        locationManager.requestAlwaysAuthorization()
    }

    /// 현재 기기의 위치를 반환합니다.
    func getCurrentLocation() -> CLLocationCoordinate2D? {
        guard let currentLocation = currentLocation else {
            return nil
        }
        return currentLocation.coordinate
    }

    /// 위치정보권한이 활성화 되었는지 판단하는 메서드
    func isLocationAuthorizationAllowed() -> Bool {
        return [
            CLAuthorizationStatus.authorizedAlways,
            .authorizedWhenInUse
        ].contains(locationManager.authorizationStatus)
    }

}

// MARK: - CLRegion

extension LocationManager {

    func registLocation(target: StationTargetType) {
        let id: String
        let location: CLLocationCoordinate2D
        let region: CLCircularRegion

        switch target {
        case .subway(let target):
            location = CLLocationCoordinate2D(latitude: target.latPos, longitude: target.lonPos)
            region = CLCircularRegion(
                center: location,
                radius: 300.0,
                identifier: target.id
            )
            id = target.id
        case .bus(let target):
            location = CLLocationCoordinate2D(latitude: target.latPos, longitude: target.lonPos)
            region = CLCircularRegion(
                center: location,
                radius: 100.0,
                identifier: target.id
            )
            id = target.id
        }

        region.notifyOnEntry = true
        region.notifyOnExit = false

        let content = configureNotificationContent(target: target)
        let trigger = UNLocationNotificationTrigger(region: region, repeats: true)
//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in
            if let error {
                print("RequestLocationNotification ERROR: " + error.localizedDescription)
            } else {
                print("RequestLocationNotification: " + request.identifier)
            }
        })
        locationManager.startMonitoring(for: region)

        print("====================")
        print("")
        debugPrint(request)
        print("region regist: \(region)")
        print("")
        print("====================")
    }

    func removeLocation(target: StationTargetType) {
        UNUserNotificationCenter
            .current()
            .removePendingNotificationRequests(withIdentifiers: [target.id])
    }

    private func configureNotificationContent(target: StationTargetType) -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()

        let notiTitle: String
        let notyBody: String

        switch target {
        case .subway(let target):
            notiTitle = "🚊\(target.name)역 등장!"
            notyBody = "\(target.destinationName)방면으로 가는 \(target.lineNumber.description)의 도착정보를 확인하세요"
            content.userInfo = ["itemType": "subway"]
        case .bus(let target):
            notiTitle = "🚌 \(target.stationName)정류장 등장!"
            notyBody = "\(target.direction)방면으로 가는 \(target.busRouteName)번의 도착정보를 확인하세요"
            content.userInfo = ["itemType": "bus"]
        }

        content.title = notiTitle
        content.body = notyBody
        content.sound = UNNotificationSound.default

        return content
    }

}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(
        _ manager: CLLocationManager,
        didChangeAuthorization status: CLAuthorizationStatus
    ) {
        switch status {
        case .notDetermined:
            manager.requestAlwaysAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            print("권한허용")
        case .denied, .restricted:
            print("권한없음")
            manager.stopUpdatingLocation()
        default:
            print("알수없음")
        }
    }

    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        guard let location = locations.last else {
            return
        }
        currentLocation = location
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        manager.stopUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        print("didStartMonitoringFor")
    }

    func locationManager(
        _ manager: CLLocationManager,
        didDetermineState state: CLRegionState,
        for region: CLRegion
    ) {
        switch state {
        case .inside:
            print("region inside")
        case .outside:
            print("region outside")
        case .unknown: break
            // do not something
        }
    }

    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        if let region = region as? CLCircularRegion {
            let identifier = region.identifier
            // TODO: 렘 업데이트??
        }
    }
}
