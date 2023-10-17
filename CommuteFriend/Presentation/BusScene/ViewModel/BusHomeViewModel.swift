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
}

protocol BusHomeViewModelOutput {
    var recentBusStationList: BehaviorSubject<[BusTarget]> { get set }
    var currentBusStationTarget: PublishSubject<BusTarget> { get set }
    var currentBusStationArrival: PublishSubject<StationArrivalResponse> { get set }
}

protocol BusHomeViewModel: BusHomeViewModelInput, BusHomeViewModelOutput { }

final class DefaultBusHomeViewModel: BusHomeViewModel {

    private let localSubwayRepository: LocalSubwayRepository
    private let subwayStationArrivalRepository: SubwayStationArrivalRepository
    private let disposeBag = DisposeBag()

    init(
        localSubwayRepository: LocalSubwayRepository,
        subwayStationArrivalRepository: SubwayStationArrivalRepository
    ) {
        self.localSubwayRepository = localSubwayRepository
        self.subwayStationArrivalRepository = subwayStationArrivalRepository
    }

    // MARK: - HomeViewModelOutput

    var recentBusStationList: BehaviorSubject<[BusTarget]> = BehaviorSubject(value: [])
    var currentBusStationTarget: PublishSubject<BusTarget> = PublishSubject()
    var currentBusStationArrival: PublishSubject<StationArrivalResponse> = PublishSubject()

}

// MARK: - HomeViewModelInput

extension DefaultBusHomeViewModel {

    func viewWillAppear() {
        fetchSubwayStationList()
    }

    func removeRecentSearchItem(with busTarget: BusTarget) {
//        localSubwayRepository.removeStation(station: subwayTarget)
        fetchSubwayStationList()
    }

    func didSelectRowAt(busTarget: BusTarget) {
//        localSubwayRepository.enrollStation(subwayTarget: subwayTarget)
        fetchSubwayStationList()
    }

}

private extension DefaultBusHomeViewModel {

    private func fetchSubwayStationList() {
//        let stationList = localSubwayRepository.fetchEnrolledStationList()
//        recentSubwayStationList.onNext(stationList)
//        if let firstItem = stationList.first {
//            currentSubwayStationTarget.onNext(firstItem)
//            fetchStationArrivalData(with: firstItem)
//        }
    }

    func fetchStationArrivalData(with subwayTarget: SubwayTarget) {
        subwayStationArrivalRepository.fetchSubwayStationArrival(with: subwayTarget) { result in
            switch result {
            case .success(let list):
                let arrivalData = StationArrivalResponse(
                    stationArrivalTarget: subwayTarget,
                    subwayArrival: list
                )
//                self.currentBusStationArrival.onNext(arrivalData)
            case .failure(let error):
                debugPrint(error)
            }
        }
    }

}

