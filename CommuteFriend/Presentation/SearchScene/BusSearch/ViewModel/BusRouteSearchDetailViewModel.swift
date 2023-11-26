//
//  BusRouteSearchDetailViewModel.swift
//  CommuteFriend
//
//  Created by 박태현 on 2023/10/18.
//

import Foundation
import RxSwift
import RxRelay

protocol BusRouteSearchDetailViewModelInput {
    func viewWillAppear()
    func didSelectItemAt(item: BusStation)
}

protocol BusRouteSearchDetailViewModelOutput {
    var busStationList: BehaviorSubject<[BusStation]> { get }
    var bus: Bus { get }
}

protocol BusRouteSearchDetailViewModel: BusRouteSearchDetailViewModelInput,
                                        BusRouteSearchDetailViewModelOutput { }

class DefaultBusRouteSearchDetailViewModel: BusRouteSearchDetailViewModel {

    private let busStationRepository: BusStationRepository
    private let localBusRepository: LocalBusRepository
    let bus: Bus
    let beginningFrom: BusSearchViewController.BeginningFrom

    init(
        busStationRepository: BusStationRepository,
        localBusRepository: LocalBusRepository,
        bus: Bus,
        beginningFrom: BusSearchViewController.BeginningFrom
    ) {
        self.busStationRepository = busStationRepository
        self.localBusRepository = localBusRepository
        self.bus = bus
        self.beginningFrom = beginningFrom
    }

    deinit {
        print("🗑️ - \(String(describing: type(of: self)))")
    }

    let busStationList: BehaviorSubject<[BusStation]> = BehaviorSubject(value: [])

    func didSelectItemAt(item: BusStation) {
        let target = BusTarget(
            stationID: item.arsID,
            stationName: item.name,
            // TODO: - 버스 방향 넣기?
            direction: item.direction,
            busRouteID: bus.id,
            busRouteName: bus.name,
            busType: bus.kind,
            latPos: item.latPos,
            lonPos: item.lonPos
        )

        switch beginningFrom {
        case .home:
            localBusRepository.enrollStation(busTarget: target)
            AnalyticsManager.shared.log(
                event: .busSearch(
                    station: item.name,
                    line: bus.name,
                    destination: item.direction
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

// MARK: - BusRouteSearchDetailViewModelInput

extension DefaultBusRouteSearchDetailViewModel {

    func viewWillAppear() {
        fetchStationByRoute()
    }

}

// MARK: - Private Methods

private extension DefaultBusRouteSearchDetailViewModel {

    func fetchStationByRoute() {
        busStationRepository
            .fetchStationByRoute(routeID: bus.id) { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let list):
                    busStationList.onNext(list)
                case .failure(let error):
                    debugPrint(error)
                }
            }
    }

}
