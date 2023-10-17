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
    associatedtype StationTargetType: StationTarget

    func viewWillAppear()
    func deleteFavoriteItem(item: FavoriteItem<StationTargetType>)
    func didAlarmButtonTouched(item: FavoriteItem<StationTargetType>)
}

protocol FavoriteViewModelOutput {
    associatedtype StationTargetType: StationTarget

    var favoriteStationItems: BehaviorSubject<[FavoriteItem<StationTargetType>]> { get set }
}

protocol FavoriteViewModel: FavoriteViewModelInput, FavoriteViewModelOutput { }

final class SubwayFavoriteViewModel: FavoriteViewModel {

    typealias StationTargetType = SubwayTarget
    typealias FavoriteItemType = FavoriteItem<StationTargetType>

    let localSubwayRepository: LocalSubwayRepository

    init(localSubwayRepository: LocalSubwayRepository) {
        self.localSubwayRepository = localSubwayRepository
    }

    var favoriteStationItems: BehaviorSubject<[FavoriteItemType]> = BehaviorSubject(value: [])
}

// MARK: - FavoriteViewModelInput

extension SubwayFavoriteViewModel {

    func viewWillAppear() {
        let favoriteStationList = localSubwayRepository.readFavoriteStationList()
        favoriteStationItems.onNext(favoriteStationList)
    }

    func deleteFavoriteItem(item: FavoriteItemType) {
        localSubwayRepository.deleteFavoriteStation(item: item)
    }

    func didAlarmButtonTouched(item: FavoriteItemType) {
        let newItem = FavoriteItemType(
            id: item.id,
            stationTarget: item.stationTarget,
            isAlarm: !item.isAlarm
        )
        localSubwayRepository.updateFavoriteStationList(item: newItem)
    }

}
