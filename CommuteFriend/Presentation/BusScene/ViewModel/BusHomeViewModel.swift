//
//  BusHomeViewModel.swift
//  CommuteFriend
//
//  Created by 박태현 on 2023/10/17.
//

import Foundation
import RxSwift
import RxRelay

protocol BusHomeViewModelInput {
    func viewWillAppear()
    func removeRecentSearchItem(with busTarget: BusTarget)
    func didSelectRowAt(busTarget: BusTarget)
    func updatePriorityStationTarget(with busTargetID: String)
}

protocol BusHomeViewModelOutput {
    var recentBusStationList: BehaviorSubject<[BusTarget]> { get set }
    var currentBusStationTarget: PublishSubject<BusTarget> { get set }
    var currentBusStationArrival: PublishSubject<StationArrivalResponse> { get set }
}

protocol BusHomeViewModel: BusHomeViewModelInput, BusHomeViewModelOutput { }

final class DefaultBusHomeViewModel: BusHomeViewModel {

    private let localBusRepository: LocalBusRepository
    private let busStationArrivalRepository: BusStationArrivalRepsitory
    private let disposeBag = DisposeBag()

    init(
        localBusRepository: LocalBusRepository,
        busStationArrivalRepository: BusStationArrivalRepsitory
    ) {
        self.localBusRepository = localBusRepository
        self.busStationArrivalRepository = busStationArrivalRepository
    }

    // MARK: - HomeViewModelOutput

    var recentBusStationList: BehaviorSubject<[BusTarget]> = BehaviorSubject(value: [])
    var currentBusStationTarget: PublishSubject<BusTarget> = PublishSubject()
    var currentBusStationArrival: PublishSubject<StationArrivalResponse> = PublishSubject()

}

// MARK: - HomeViewModelInput

extension DefaultBusHomeViewModel {

    func viewWillAppear() {
        fetchBusStationList()
    }

    func removeRecentSearchItem(with busTarget: BusTarget) {
        localBusRepository.removeStation(station: busTarget)
        fetchBusStationList()
    }

    func didSelectRowAt(busTarget: BusTarget) {
        localBusRepository.enrollStation(busTarget: busTarget)
        fetchBusStationList()
    }

    func updatePriorityStationTarget(with busTargetID: String) {
        if let item = localBusRepository.readFavoriteStationTarget(with: busTargetID) {
            localBusRepository.enrollStation(busTarget: item)
            fetchBusStationList()
        }
    }

}

private extension DefaultBusHomeViewModel {

    private func fetchBusStationList() {
        let stationList = localBusRepository.fetchEnrolledStationList()
        recentBusStationList.onNext(stationList)
        if let firstItem = stationList.first {
            currentBusStationTarget.onNext(firstItem)
            fetchStationArrivalData(with: firstItem)
        }
    }

    func fetchStationArrivalData(with busTarget: BusTarget) {
        busStationArrivalRepository
            .fetchBusStationArrivalData(station: busTarget) { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let list):
                    let speceficList = list.filter { $0.busRouteName == busTarget.busRouteName }
                    let arrivalData = StationArrivalResponse(
                        stationArrivalTarget: .bus(target: busTarget),
                        stationArrival: .bus(arrival: speceficList)
                    )
                    currentBusStationArrival.onNext(arrivalData)
                case .failure(let error):
                    debugPrint(error)
                }
            }
    }

}
