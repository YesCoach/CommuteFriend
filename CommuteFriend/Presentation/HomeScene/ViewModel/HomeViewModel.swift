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
    func updatePriorityStationTarget(with subwaTargetID: String)
}

protocol HomeViewModelOutput {
    var recentSubwayStationList: BehaviorSubject<[SubwayTarget]> { get set }
    var currentSubwayStationTarget: BehaviorSubject<SubwayTarget?> { get set }
    var currentSubwayStationArrival: PublishSubject<StationArrivalResponse> { get set }
}

protocol HomeArrivalViewModel {
    func refreshCurrentStationTarget()
}

protocol HomeViewModel: HomeViewModelInput, HomeViewModelOutput, HomeArrivalViewModel { }

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
    var currentSubwayStationTarget: BehaviorSubject<SubwayTarget?> = BehaviorSubject(value: nil)
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

    func updatePriorityStationTarget(with subwaTargetID: String) {
        if let item = localSubwayRepository.readFavoriteStationTarget(with: subwaTargetID) {
            localSubwayRepository.enrollStation(subwayTarget: item)
            fetchSubwayStationList()
        }
    }

    func refreshCurrentStationTarget() {
        if let subwayTarget = try? currentSubwayStationTarget.value() {
            fetchStationArrivalData(with: subwayTarget)
        }
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
                    stationArrivalTarget: .subway(target: subwayTarget),
                    stationArrival: .subway(arrival: list)
                )
                self.currentSubwayStationArrival.onNext(arrivalData)
            case .failure(let error):
                debugPrint(error)
            }
        }
    }

}
