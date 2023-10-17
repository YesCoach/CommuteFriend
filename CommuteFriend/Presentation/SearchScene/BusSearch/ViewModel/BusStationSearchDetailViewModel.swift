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

    init(
        busStation: BusStation,
        busStationArrivalRepository: BusStationArrivalRepsitory,
        localBusRepository: LocalBusRepository
    ) {
        self.busStation = busStation
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
            busRouteName: item.busRouteName
        )

        localBusRepository.enrollStation(busTarget: target)
        NotificationCenter.default.post(name: .busHomeUpdateNotification, object: nil)
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
            busRouteName: nil
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
