//
//  DIContainer.swift
//  CommuteFriend
//
//  Created by 박태현 on 2023/10/12.
//

import Foundation

final class DIContainer {

    static let shared = DIContainer()

    private init() { }

    // MARK: - Network Service

    lazy var networkManager: NetworkService = NetworkManager.shared

    // MARK: - Persistentr Storage

    lazy var searchHistoryStorage: SearchHistoryStorage = UserDefaultsSearchHistory()
    lazy var subwayStationStorage: SubwayStationStorage = RealmSubwayStationStorage(realmStorage: .shared)
    lazy var busStationStorage: BusStationStorage = RealmBusStationStorage(realmStorage: .shared)
    lazy var userStorage: UserStorage = UserStorage(realmStorage: .shared)

    // MARK: - ViewController

    func makeHomeViewController() -> HomeViewController {
        return HomeViewController(viewModel: makeHomeViewModel())
    }

    func makeSubwaySearchViewController(
        beginningFrom: SubwaySearchViewController.BeginningFrom
    ) -> SubwaySearchViewController {
        return SubwaySearchViewController(
            viewModel: makeSubwaySearchViewModel(),
            beginningFrom: beginningFrom
        )
    }

    func makeBusSearchViewController(
        beginningFrom: BusSearchViewController.BeginningFrom
    ) -> BusSearchViewController {
        return BusSearchViewController(
            viewModel: makeBusSearchViewModel(),
            beginningFrom: beginningFrom
        )
    }

    func makeSubwaySearchSelectionViewController(
        station: SubwayStation,
        beginningFrom: SubwaySearchViewController.BeginningFrom
    ) -> SubwaySearchSelectionViewController {
        switch beginningFrom {
        case .home:
            return SubwaySearchSelectionViewController(
                viewModel: makeSubwaySearchSelectionViewModel(
                    station: station
                )
            )
        case .favorite:
            return SubwaySearchSelectionViewController(
                viewModel: makeFavoriteSubwaySearchSelectionViewModel(
                    station: station
                )
            )
        }
    }

    func makeSubwayFavoriteViewController() -> FavoriteViewController {
        return FavoriteViewController(
            viewModel: makeSubwayFavoriteViewModel(),
            beginningFrom: .subway
        )
    }

    // MARK: Bus

    func makeBusHomeViewController() -> BusHomeViewController {
        return BusHomeViewController(viewModel: makeBusHomeViewModel())
    }

    func makeBusStationSearchDetailViewController(
        busStation: BusStation,
        beginningFrom: BusSearchViewController.BeginningFrom
    ) -> BusStationSearchDetailViewController {
        return BusStationSearchDetailViewController(
            viewModel: makeBusStationSearchDetailViewModel(
                busStation: busStation,
                beginningFrom: beginningFrom
            )
        )
    }

    func makeBusRouteSearchDetailViewController(
        bus: Bus,
        beginningFrom: BusSearchViewController.BeginningFrom
    ) -> BusRouteSearchDetailViewController {
        return BusRouteSearchDetailViewController(
            viewModel: makeBusRouteSearchDetailViewModel(
                bus: bus,
                beginningFrom: beginningFrom
            )
        )
    }

    func makeBusFavoriteViewController() -> FavoriteViewController {
        return FavoriteViewController(
            viewModel: makeBusFavoriteViewModel(),
            beginningFrom: .bus
        )
    }

    // MARK: Setting

    func makeSettingViewController() -> SettingViewController {
        return SettingViewController(viewModel: makeSettingViewModel())
    }

}

extension DIContainer {

    // MARK: - ViewModel

    private func makeHomeViewModel() -> HomeViewModel {
        return DefaultHomeViewModel(
            localSubwayRepository: makeLocalSubwayRepository(),
            subwayStationArrivalRepository: makeSubwayStationArrivalRepository()
        )
    }

    // MARK: Subway

    private func makeSubwaySearchViewModel() -> SubwaySearchViewModel {
        return DefaultSubwaySearchViewModel(
            searchHistoryRepository: makeSearchHistoryRepository(),
            subwayRepository: makeLocalSubwayRepository()
        )
    }

    private func makeSubwaySearchSelectionViewModel(
        station: SubwayStation
    ) -> SubwaySearchSelectionViewModel {
        return DefaultSubwaySearchSelectionViewModel(
            station: station,
            localSubwayRepository: makeLocalSubwayRepository()
        )
    }

    private func makeFavoriteSubwaySearchSelectionViewModel(
        station: SubwayStation
    ) -> SubwaySearchSelectionViewModel {
        return FavoriteSubwaySearchSelectionViewModel(
            station: station,
            localSubwayRepository: makeLocalSubwayRepository()
        )
    }

    private func makeSubwayFavoriteViewModel() -> FavoriteViewModel {
        return SubwayFavoriteViewModel(localSubwayRepository: makeLocalSubwayRepository())
    }

    // MARK: Bus

    private func makeBusSearchViewModel() -> BusSearchViewModel {
        return DefaultBusSearchViewModel(
            searchHistoryRepository: makeSearchHistoryRepository(),
            localBusRepository: makeLocalBusRepository(),
            busRepository: makeBusRepository()
        )
    }

    private func makeBusHomeViewModel() -> BusHomeViewModel {
        return DefaultBusHomeViewModel(
            localBusRepository: makeLocalBusRepository(),
            busStationArrivalRepository: makeBusStationArrivalRepository()
        )
    }

    private func makeBusStationSearchDetailViewModel(
        busStation: BusStation,
        beginningFrom: BusSearchViewController.BeginningFrom
    ) -> BusStationSearchDetailViewModel {
        return DefaultBusStationSearchDetailViewModel(
            busStation: busStation, beginningFrom: beginningFrom,
            busStationArrivalRepository: makeBusStationArrivalRepository(),
            localBusRepository: makeLocalBusRepository()
        )
    }

    private func makeBusRouteSearchDetailViewModel(
        bus: Bus,
        beginningFrom: BusSearchViewController.BeginningFrom
    ) -> BusRouteSearchDetailViewModel {
        return DefaultBusRouteSearchDetailViewModel(
            busStationRepository: makeBusStationRepository(),
            localBusRepository: makeLocalBusRepository(),
            bus: bus,
            beginningFrom: beginningFrom
        )
    }

    private func makeBusFavoriteViewModel() -> FavoriteViewModel {
        return BusFavoriteViewModel(localBusRepository: makeLocalBusRepository())
    }

    private func makeSettingViewModel() -> SettingViewModel {
        return SettingViewModel()
    }

    // MARK: - Repository

    private func makeSearchHistoryRepository() -> SearchHistoryRepository {
        return SearchHistoryRepository(searchHistoryStorage: searchHistoryStorage)
    }

    private func makeLocalSubwayRepository() -> LocalSubwayRepository {
        return LocalSubwayRepository(
            subwayStationStorage: subwayStationStorage
        )
    }

    private func makeLocalBusRepository() -> LocalBusRepository {
        return LocalBusRepository(busStationStorage: busStationStorage)
    }

    private func makeSubwayStationArrivalRepository() -> SubwayStationArrivalRepository {
        return SubwayStationArrivalRepository(networkManager: networkManager)
    }

    private func makeBusStationArrivalRepository() -> BusStationArrivalRepsitory {
        return BusStationArrivalRepsitory(networkManager: networkManager)
    }

    private func makeBusRepository() -> BusRepository {
        return BusRepository(networkManager: networkManager)
    }

    private func makeBusStationRepository() -> BusStationRepository {
        return BusStationRepository(networkManager: networkManager)
    }

}
