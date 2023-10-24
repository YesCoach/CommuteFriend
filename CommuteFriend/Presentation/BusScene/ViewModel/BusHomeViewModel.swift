//
//  BusHomeViewModel.swift
//  CommuteFriend
//
//  Created by 박태현 on 2023/10/17.
//

import Foundation
import RxSwift
import RxRelay
import ActivityKit

protocol BusHomeViewModelInput {
    func viewWillAppear()
    func removeRecentSearchItem(with busTarget: BusTarget)
    func didSelectRowAt(busTarget: BusTarget)
    func updatePriorityStationTarget(with busTargetID: String)
}

protocol BusHomeViewModelOutput {
    var recentBusStationList: BehaviorSubject<[BusTarget]> { get set }
    var currentBusStationTarget: BehaviorSubject<BusTarget?> { get set }
    var currentBusStationArrival: PublishSubject<StationArrivalResponse> { get set }
}

protocol BusHomeViewModel: BusHomeViewModelInput, BusHomeViewModelOutput, HomeArrivalViewModel { }

final class DefaultBusHomeViewModel: BusHomeViewModel {

    private let localBusRepository: LocalBusRepository
    private let busStationArrivalRepository: BusStationArrivalRepsitory
    private let disposeBag = DisposeBag()
    private let liveActivityManager = ArrivalWidgetManager.shared

    init(
        localBusRepository: LocalBusRepository,
        busStationArrivalRepository: BusStationArrivalRepsitory
    ) {
        self.localBusRepository = localBusRepository
        self.busStationArrivalRepository = busStationArrivalRepository
        bindData()
    }

    // MARK: - HomeViewModelOutput

    var recentBusStationList: BehaviorSubject<[BusTarget]> = BehaviorSubject(value: [])
    var currentBusStationTarget: BehaviorSubject<BusTarget?> = BehaviorSubject(value: nil)
    var currentBusStationArrival: PublishSubject<StationArrivalResponse> = PublishSubject()

    private func bindData() {
        currentBusStationTarget
            .bind(with: self) { object, target in
                if let target {
                    object.fetchStationArrivalData(with: target)
                }
            }
            .disposed(by: disposeBag)
    }

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

    func refreshCurrentStationTarget() {
        if let busTarget = try? currentBusStationTarget.value() {
            fetchStationArrivalData(with: busTarget)
        }
    }

}

private extension DefaultBusHomeViewModel {

    // 최근검색 목록 불러오기
    private func fetchBusStationList() {
        let stationList = localBusRepository.fetchEnrolledStationList()
        recentBusStationList.onNext(stationList)
        // 최근검색의 가장 최근역을 홈화면에 보여줌
        if let firstItem = stationList.first {
            currentBusStationTarget.onNext(firstItem)
        }
    }

    /// 정류장의 도착정보를 패칭
    func fetchStationArrivalData(with busTarget: BusTarget) {
        busStationArrivalRepository
            .fetchBusStationArrivalData(station: busTarget) { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let list):
                    let specificList = list.filter { $0.busRouteName == busTarget.busRouteName }
                    let arrivalData = StationArrivalResponse(
                        stationArrivalTarget: .bus(target: busTarget),
                        stationArrival: .bus(arrival: specificList)
                    )
                    currentBusStationArrival.onNext(arrivalData)
                    if specificList.first?.firstCalculatedeTime != 0 {
                        onLiveActivity(with: arrivalData)
                    } else {
                        Task { [weak self] in
                            self?.endLiveActivity()
                        }
                    }
                case .failure(let error):
                    debugPrint(error)
                }
            }
    }

}

// MARK: - LiveAcitivity

private extension DefaultBusHomeViewModel {

    /// 라이브 액티비티 활성화
    func onLiveActivity(with data: StationArrivalResponse) {
        var arrivalTime: ClosedRange<Date>? = nil

        /// 도착정보 값으로 content 구성
        switch data.stationArrival {
        case .bus(let arrival):
            if let remainTime = arrival.first?.firstCalculatedeTime,
               remainTime != 0
            {
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
                type: .bus
            )
        } else {
            // 액티비티를 종료
            endLiveActivity()
        }
    }

    func endLiveActivity() {
        liveActivityManager.stop()
    }
}
