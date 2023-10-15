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
    var currentSubwayStationArrival: BehaviorSubject<SubwayArrival?> { get set }
}

protocol HomeViewModel: HomeViewModelInput, HomeViewModelOutput { }

final class DefaultHomeViewModel: HomeViewModel {

    private let localSubwayRepository: LocalSubwayRepository
    private let disposeBag = DisposeBag()

    init(
        localSubwayRepository: LocalSubwayRepository
    ) {
        self.localSubwayRepository = localSubwayRepository
    }

    // MARK: - HomeViewModelOutput

    var recentSubwayStationList: BehaviorSubject<[SubwayTarget]> = BehaviorSubject(value: [])
    var currentSubwayStationArrival: BehaviorSubject<SubwayArrival?> = BehaviorSubject(value: nil)

}

// MARK: - HomeViewModelInput

extension DefaultHomeViewModel {

    func viewWillAppear() {
        recentSubwayStationList.onNext(localSubwayRepository.fetchEnrolledStationList())
    }

    func removeRecentSearchItem(with subwayTarget: SubwayTarget) {
        localSubwayRepository.removeStation(station: subwayTarget)
        recentSubwayStationList.onNext(localSubwayRepository.fetchEnrolledStationList())
    }

    func didSelectRowAt(subwayTarget: SubwayTarget) {
        localSubwayRepository.enrollStation(subwayTarget: subwayTarget)
        recentSubwayStationList.onNext(localSubwayRepository.fetchEnrolledStationList())
    }

}
