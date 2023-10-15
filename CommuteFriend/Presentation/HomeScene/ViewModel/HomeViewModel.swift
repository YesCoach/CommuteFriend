//
//  HomeViewModel.swift
//  CommuteFriend
//
//  Created by 박태현 on 2023/10/15.
//

import Foundation
import RxSwift
import RxRelay

protocol HomeViewModelInput {
    func viewWillAppear()
    func removeRecentSearchItem(with subwayTarget: SubwayTarget)
    func didSelectRowAt(subwayTarget: SubwayTarget)
}

protocol HomeViewModelOutput {
    var recentSubwayStationList: BehaviorSubject<[SubwayTarget]> { get set }
    var currentSubwayStationTarget: PublishSubject<SubwayTarget> { get set }
    var currentSubwayStationArrival: PublishSubject<StationArrivalResponse> { get set }
}

protocol HomeViewModel: HomeViewModelInput, HomeViewModelOutput { }

final class DefaultHomeViewModel: HomeViewModel {

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

    var recentSubwayStationList: BehaviorSubject<[SubwayTarget]> = BehaviorSubject(value: [])
    var currentSubwayStationTarget: PublishSubject<SubwayTarget> = PublishSubject()
    var currentSubwayStationArrival: PublishSubject<StationArrivalResponse> = PublishSubject()

}

// MARK: - HomeViewModelInput

extension DefaultHomeViewModel {

    func viewWillAppear() {
        fetchSubwayStationList()
    }

    func removeRecentSearchItem(with subwayTarget: SubwayTarget) {
        localSubwayRepository.removeStation(station: subwayTarget)
        fetchSubwayStationList()
    }

    func didSelectRowAt(subwayTarget: SubwayTarget) {
        localSubwayRepository.enrollStation(subwayTarget: subwayTarget)
        fetchSubwayStationList()
    }

}

private extension DefaultHomeViewModel {

    private func fetchSubwayStationList() {
        let stationList = localSubwayRepository.fetchEnrolledStationList()
        recentSubwayStationList.onNext(stationList)
        if let firstItem = stationList.first {
            currentSubwayStationTarget.onNext(firstItem)
            fetchStationArrivalData(with: firstItem)
        }
    }

    func fetchStationArrivalData(with subwayTarget: SubwayTarget) {
        subwayStationArrivalRepository.fetchSubwayStationArrival(with: subwayTarget) { result in
            switch result {
            case .success(let list):
                let arrivalData = StationArrivalResponse(
                    stationArrivalTarget: subwayTarget,
                    subwayArrival: list
                )
                self.currentSubwayStationArrival.onNext(arrivalData)
            case .failure(let error):
                debugPrint(error)
            }
        }
    }

}
