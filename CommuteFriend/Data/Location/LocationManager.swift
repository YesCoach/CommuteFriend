//
//  LocationManager.swift
//  CommuteFriend
//
//  Created by 박태현 on 2023/10/18.
//

import CoreLocation

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
        locationManager.allowsBackgroundLocationUpdates = true
        // 백그라운드에서 위치 서비스를 사용중임을 나타내기 위한 설정
        locationManager.showsBackgroundLocationIndicator = true

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

        let location: CLLocationCoordinate2D
        let region: CLCircularRegion

        switch target {
        case .subway(let target):
            location = CLLocationCoordinate2D(latitude: target.latPos, longitude: target.lonPos)
            region = CLCircularRegion(
                center: location,
                radius: 200.0,
                identifier: target.id
            )
        case .bus(let target):
            location = CLLocationCoordinate2D(latitude: target.latPos, longitude: target.lonPos)
            region = CLCircularRegion(
                center: location,
                radius: 100.0,
                identifier: target.id
            )
        }

        region.notifyOnEntry = true
        region.notifyOnExit = true

        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false

        locationManager.startUpdatingLocation()
        locationManager.startMonitoring(for: region)
        print("region regist: \(region)")
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(
        _ manager: CLLocationManager,
        didChangeAuthorization status: CLAuthorizationStatus
    ) {
        switch status {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
            manager.stopUpdatingLocation()
        case .authorizedWhenInUse, .authorizedAlways:
            manager.startUpdatingLocation()
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
        manager.stopUpdatingLocation()
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
}
