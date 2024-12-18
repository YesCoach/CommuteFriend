//
//  HomeViewModel.swift
//  CommuteFriend
//
//  Created by 박태현 on 2023/10/15.
//

import Foundation
import RxSwift
import RxRelay
import ActivityKit

// MARK: - Input

protocol HomeViewModelInput {
    func viewWillAppear()
    func removeRecentSearchItem(with subwayTarget: SubwayTarget)
    func didSelectRowAt(subwayTarget: SubwayTarget)
    func updatePriorityStationTarget(with subwaTargetID: String)
}

// MARK: - Output

protocol HomeViewModelOutput {
    var recentSubwayStationList: BehaviorSubject<[SubwayTarget]> { get set }
    var currentSubwayStationArrival: BehaviorSubject<StationArrivalResponse?> { get set }
    var isNowFetching: BehaviorRelay<Bool> { get set }
}

protocol HomeArrivalViewModel {
    func refreshCurrentStationTarget()
}

protocol HomeViewModel: HomeViewModelInput, HomeViewModelOutput, HomeArrivalViewModel { }

final class DefaultHomeViewModel: HomeViewModel {

    private let localSubwayRepository: LocalSubwayRepository
    private let subwayStationArrivalRepository: SubwayStationArrivalRepository

    private let liveActivityManager = ArrivalWidgetManager.shared

    private let disposeBag = DisposeBag()
    private let cancelBag = TaskCancelBag()

    // MARK: - DI

    init(
        localSubwayRepository: LocalSubwayRepository,
        subwayStationArrivalRepository: SubwayStationArrivalRepository
    ) {
        self.localSubwayRepository = localSubwayRepository
        self.subwayStationArrivalRepository = subwayStationArrivalRepository
        bindData()
    }

    // MARK: - HomeViewModelOutput

    var recentSubwayStationList: BehaviorSubject<[SubwayTarget]> = BehaviorSubject(value: [])
    var currentSubwayStationTarget: BehaviorSubject<SubwayTarget?> = BehaviorSubject(value: nil)
    var currentSubwayStationArrival: BehaviorSubject<StationArrivalResponse?> = BehaviorSubject(value: nil)

    var isNowFetching: BehaviorRelay<Bool> = BehaviorRelay(value: false)

    private func bindData() {
        // 현재 역을 받아오면 도착정보를 패치
        currentSubwayStationTarget
            .bind(with: self) { owner, target in
                if let target {
                    Task { [weak owner] in
                        await owner?.fetchStationArrivalData(with: target)
                    }
                    .store(in: owner.cancelBag)
                }
            }
            .disposed(by: disposeBag)
    }

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

    func updatePriorityStationTarget(with subwayTargetID: String) {
        if let item = localSubwayRepository.readFavoriteStationTarget(with: subwayTargetID) {
            localSubwayRepository.enrollStation(subwayTarget: item)
            fetchSubwayStationList()
        }
    }

    // 현재 역의 도착정보 새로고침
    func refreshCurrentStationTarget() {

        Task { [weak self] in
            guard let self else { return }
            if let subwayTarget = try? currentSubwayStationTarget.value() {
                await fetchStationArrivalData(with: subwayTarget)
            }
        }.store(in: cancelBag)

    }

}

private extension DefaultHomeViewModel {

    /// 최근검색 목록 불러오기
    private func fetchSubwayStationList() {
        let stationList = localSubwayRepository.fetchEnrolledStationList()
        recentSubwayStationList.onNext(stationList)

        /// 최근검색의 가장 최근역을 홈화면에 보여줌
        if let firstItem = stationList.first {
            currentSubwayStationTarget.onNext(firstItem)
        }
    }

    /// 역의 도착정보를 패칭
    func fetchStationArrivalData(with subwayTarget: SubwayTarget) async {
        do {
            let data = try await subwayStationArrivalRepository
                .fetchSubwayStationArrival(with: subwayTarget)

            let arrivalData = StationArrivalResponse(
                stationArrivalTarget: .subway(target: subwayTarget),
                stationArrival: .subway(arrival: data)
            )

            currentSubwayStationArrival.onNext(arrivalData)

            if data.isEmpty == false {
                onLiveActivity(with: arrivalData)
            } else {
                endLiveActivity()
            }
        } catch {
            debugPrint(error)
        }
    }

}

// MARK: - LiveAcitivity

private extension DefaultHomeViewModel {

    /// 라이브 액티비티 활성화
    func onLiveActivity(with data: StationArrivalResponse) {
        var arrivalTime: ClosedRange<Date>? = nil

        /// 도착정보 값으로 content 구성
        switch data.stationArrival {
        case .subway(let arrival):
            if let remainTime = arrival[safe: 0]?.remainSecond, remainTime != 0 {
                if let future = Calendar.current.date(
                    byAdding: .second,
                    value: remainTime,
                    to: Date()
                ) {
                    arrivalTime = Date.now...future
                }
            }
        default: break
        }

        // 남은 시간이 0이 아닐경우 액티비티 설정
        if let arrivalTime {
            liveActivityManager.start(
                stationName: data.stationArrivalTarget.stationName,
                stationLine: data.stationArrivalTarget.stationLine,
                stationLineColorName: data.stationArrivalTarget.lineColorName,
                nextStation: data.stationArrivalTarget.directionType,
                timer: arrivalTime,
                type: .subway
            )
        } else {
            endLiveActivity()
        }
    }

    func endLiveActivity() {
        liveActivityManager.stop()
    }
}
