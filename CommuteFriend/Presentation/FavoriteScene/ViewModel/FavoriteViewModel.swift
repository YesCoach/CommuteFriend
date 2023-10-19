//
//  FavoriteViewModel.swift
//  CommuteFriend
//
//  Created by 박태현 on 2023/10/16.
//

import Foundation
import RxSwift
import RxCocoa

protocol FavoriteViewModelInput {
    func viewWillAppear()
    func deleteFavoriteItem(item: FavoriteItem)
    func didAlarmButtonTouched(item: FavoriteItem)
}

protocol FavoriteViewModelOutput {
    var favoriteStationItems: BehaviorSubject<[FavoriteItem]> { get set }
}

protocol FavoriteViewModel: FavoriteViewModelInput, FavoriteViewModelOutput { }

final class SubwayFavoriteViewModel: FavoriteViewModel {

    let localSubwayRepository: LocalSubwayRepository

    init(localSubwayRepository: LocalSubwayRepository) {
        self.localSubwayRepository = localSubwayRepository
    }

    var favoriteStationItems: BehaviorSubject<[FavoriteItem]> = BehaviorSubject(value: [])
}

// MARK: - FavoriteViewModelInput

extension SubwayFavoriteViewModel {

    func viewWillAppear() {
        let favoriteStationList = localSubwayRepository.readFavoriteStationList()
        favoriteStationItems.onNext(favoriteStationList)
    }

    func deleteFavoriteItem(item: FavoriteItem) {
        localSubwayRepository.deleteFavoriteStation(item: item)
        let favoriteStationList = localSubwayRepository.readFavoriteStationList()
        favoriteStationItems.onNext(favoriteStationList)
    }

    func didAlarmButtonTouched(item: FavoriteItem) {
        let newItem = FavoriteItem(
            id: item.id,
            stationTarget: item.stationTarget,
            isAlarm: !item.isAlarm
        )
        localSubwayRepository.updateFavoriteStationList(item: newItem)
        if newItem.isAlarm {
            LocationManager.shared.registLocation(target: newItem.stationTarget)
        }
    }

}

final class BusFavoriteViewModel: FavoriteViewModel {

    let localBusRepository: LocalBusRepository

    init(localBusRepository: LocalBusRepository) {
        self.localBusRepository = localBusRepository
    }

    var favoriteStationItems: BehaviorSubject<[FavoriteItem]> = BehaviorSubject(value: [])
}

// MARK: - FavoriteViewModelInput

extension BusFavoriteViewModel {

    func viewWillAppear() {
        let favoriteStationList = localBusRepository.readFavoriteStationList()
        favoriteStationItems.onNext(favoriteStationList)
    }

    func deleteFavoriteItem(item: FavoriteItem) {
        localBusRepository.deleteFavoriteStation(item: item)
        let favoriteStationList = localBusRepository.readFavoriteStationList()
        favoriteStationItems.onNext(favoriteStationList)
    }

    func didAlarmButtonTouched(item: FavoriteItem) {
        let newItem = FavoriteItem(
            id: item.id,
            stationTarget: item.stationTarget,
            isAlarm: !item.isAlarm
        )
        localBusRepository.updateFavoriteStationList(item: newItem)
    }

}
