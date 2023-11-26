//
//  BusStationSearchDetailViewModel.swift
//  CommuteFriend
//
//  Created by 박태현 on 2023/10/18.
//

import Foundation
import RxSwift
import RxRelay

protocol BusStationSearchDetailViewModelInput {
    func viewWillAppear()
    func didSelectItemAt(item: BusArrival)
}

protocol BusStationSearchDetailViewModelOutput {
    var busRouteItems: BehaviorSubject<[BusArrival]> { get }
    var busStation: BusStation { get }
}

protocol BusStationSearchDetailViewModel: BusStationSearchDetailViewModelInput,
                                          BusStationSearchDetailViewModelOutput { }

class DefaultBusStationSearchDetailViewModel: BusStationSearchDetailViewModel {

    private let busStationArrivalRepository: BusStationArrivalRepsitory
    private let localBusRepository: LocalBusRepository
    let busStation: BusStation
    let beginningFrom: BusSearchViewController.BeginningFrom

    init(
        busStation: BusStation,
        beginningFrom: BusSearchViewController.BeginningFrom,
        busStationArrivalRepository: BusStationArrivalRepsitory,
        localBusRepository: LocalBusRepository
    ) {
        self.busStation = busStation
        self.beginningFrom = beginningFrom
        self.busStationArrivalRepository = busStationArrivalRepository
        self.localBusRepository = localBusRepository
    }

    deinit {
        print("🗑️ - \(String(describing: type(of: self)))")
    }

    let busRouteItems: BehaviorSubject<[BusArrival]> = BehaviorSubject(value: [])

    func didSelectItemAt(item: BusArrival) {
        let target = BusTarget(
            stationID: item.stationID,
            stationName: item.stationName,
            direction: item.nextStationName,
            busRouteID: item.busRouteID,
            busRouteName: item.busRouteName,
            busType: BusType(rawValue: item.busRouteType),
            latPos: item.latPos,
            lonPos: item.lonPos
        )

        switch beginningFrom {
        case .home:
            localBusRepository.enrollStation(busTarget: target)
            AnalyticsManager.shared.log(
                event: .busSearch(
                    station: item.stationName,
                    line: item.busRouteName,
                    destination: item.nextStationName
                )
            )
            NotificationCenter.default.post(name: .busHomeUpdateNotification, object: nil)
        case .favorite:
            do {
                try localBusRepository.enrollFavoriteStation(
                    item: .init(stationTarget: .bus(target: target), isAlarm: true)
                )
                LocationManager.shared.registLocation(target: .bus(target: target))
            } catch {
                debugPrint(error)
            }
            NotificationCenter.default.post(name: .favoriteUpdateNotification, object: nil)
        }

    }

}

// MARK: - BusStationSearchDetailViewModelInput

extension DefaultBusStationSearchDetailViewModel {

    func viewWillAppear() {
        fetchRouteByStation()
    }

}

private extension DefaultBusStationSearchDetailViewModel {

    func fetchRouteByStation() {
        let target = BusTarget(
            stationID: busStation.arsID,
            stationName: busStation.name,
            direction: busStation.direction,
            busRouteID: nil,
            busRouteName: nil,
            busType: nil,
            latPos: busStation.latPos,
            lonPos: busStation.lonPos
        )

        busStationArrivalRepository.fetchBusStationArrivalData(
            station: target
        ) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let list):
                busRouteItems.onNext(list)
            case .failure(let error):
                debugPrint(error)
            }
        }
    }

}
