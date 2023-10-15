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
    lazy var userStorage: UserStorage = UserStorage(realmStorage: .shared)

    // MARK: - ViewController

    func makeHomeViewController() -> HomeViewController {
        return HomeViewController(viewModel: makeHomeViewModel())
    }

    func makeSubwaySearchViewController() -> SubwaySearchViewController {
        return SubwaySearchViewController(viewModel: makeSubwaySearchViewModel())
    }

    func makeBusSearchViewController() -> BusSearchViewController {
        return BusSearchViewController(viewModel: makeBusSearchViewModel())
    }

    func makeSubwaySearchSelectionViewController(
        station: SubwayStation
    ) -> SubwaySearchSelectionViewController {
        return SubwaySearchSelectionViewController(
            viewModel: makeSubwaySearchSelectionViewModel(
                station: station
            )
        )
    }

}

private extension DIContainer {

    // MARK: - ViewModel

    private func makeHomeViewModel() -> HomeViewModel {
        return DefaultHomeViewModel(
            localSubwayRepository: makeLocalSubwayRepository(),
            subwayStationArrivalRepository: makeSubwayStationArrivalRepository()
        )
    }

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

    private func makeBusSearchViewModel() -> BusSearchViewModel {
        return DefaultBusSearchViewModel(
            searchHistoryRepository: makeSearchHistoryRepository(),
            busRepository: makeLocalBusRepository()
        )
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
        return LocalBusRepository.shared
    }

    private func makeSubwayStationArrivalRepository() -> SubwayStationArrivalRepository {
        return SubwayStationArrivalRepository(networkManager: networkManager)
    }

}
