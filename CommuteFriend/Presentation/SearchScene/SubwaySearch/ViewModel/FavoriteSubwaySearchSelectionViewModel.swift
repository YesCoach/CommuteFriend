//
//  FavoriteSubwaySearchSelectionViewModel.swift
//  CommuteFriend
//
//  Created by 박태현 on 2023/10/16.
//

import Foundation
import RxSwift
import RxRelay

final class FavoriteSubwaySearchSelectionViewModel: SubwaySearchSelectionViewModel {

    let station: SubwayStation
    private let localSubwayRepository: LocalSubwayRepository

    init(
        station: SubwayStation,
        localSubwayRepository: LocalSubwayRepository
    ) {
        self.station = station
        self.localSubwayRepository = localSubwayRepository
    }

    deinit {
        print("🗑️ - \(String(describing: type(of: self)))")
    }

    var upStation: BehaviorRelay<SubwayStation?> = BehaviorRelay(value: nil)
    var downStation: BehaviorRelay<SubwayStation?> = BehaviorRelay(value: nil)
    var splitStation: BehaviorRelay<SubwayStation?> = BehaviorRelay(value: nil)

}

// MARK: - SubwaySearchDirectionSelectViewModelInput

extension FavoriteSubwaySearchSelectionViewModel {

    func didSelectDirection(direction: UpDownDirection, stationName: String) {
        let subwayTarget = SubwayTarget(
            name: station.name,
            lineNumber: station.lineNumber,
            destinationName: stationName,
            upDownDirection: direction,
            latPos: station.latPos,
            lonPos: station.lonPos
        )
        do {
            try localSubwayRepository.enrollFavoriteStation(
                item: .init(stationTarget: .subway(target: subwayTarget), isAlarm: true)
            )
            AnalyticsManager.shared.log(
                event: .subwayFavoriteEnroll(
                    station: station.name,
                    line: station.lineNumber.description,
                    destination: stationName
                )
            )
            LocationManager.shared.registLocation(target: .subway(target: subwayTarget))
        } catch {
            debugPrint(error)
        }
        NotificationCenter.default.post(name: .favoriteUpdateNotification, object: nil)
    }

    func viewDidLoad() {
        if let upStationCode = station.upStation,
           let upStation = localSubwayRepository.stationDictionary[upStationCode] {
            self.upStation.accept(upStation)
        }

        if let downStationCode = station.downStation,
            let downStation = localSubwayRepository.stationDictionary[downStationCode] {
            self.downStation.accept(downStation)
        }

        if let splitStation = station.splitStation,
           let splitStation = localSubwayRepository.stationDictionary[splitStation] {
            self.splitStation.accept(splitStation)
        }
    }

}
