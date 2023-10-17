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

    init(
        busStationRepository: BusStationRepository,
        localBusRepository: LocalBusRepository,
        bus: Bus
    ) {
        self.busStationRepository = busStationRepository
        self.localBusRepository = localBusRepository
        self.bus = bus
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
            busRouteName: bus.name
        )

        localBusRepository.enrollStation(busTarget: target)
        NotificationCenter.default.post(name: .busHomeUpdateNotification, object: nil)
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
