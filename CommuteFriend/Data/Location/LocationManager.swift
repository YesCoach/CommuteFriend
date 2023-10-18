//
//  LocationManager.swift
//  CommuteFriend
//
//  Created by 박태현 on 2023/10/18.
//

import CoreLocation

enum LocationManagerError: Error {
    case invalidLocation
    case emptyPlacemark
    case emptyPlacemarkLocality
    case emptyPlacemarkSubLocality
    case emptyLocationValue
}

protocol LocationManagerDelegate: AnyObject {
    func didUpdateLocation()
    func didUpdateAuthorization()
}

final class LocationManager: NSObject {

    static let shared = LocationManager()

    private let locationManager = CLLocationManager()
    private var currentLocation: CLLocation?

    weak var delegate: LocationManagerDelegate?

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

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(
        _ manager: CLLocationManager,
        didChangeAuthorization status: CLAuthorizationStatus
    ) {
        delegate?.didUpdateAuthorization()
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
        delegate?.didUpdateLocation()
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        manager.stopUpdatingLocation()
    }
}
