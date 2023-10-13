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

    // MARK: - ViewController

    func makeSubwaySearchViewController() -> SubwaySearchViewController {
        return SubwaySearchViewController(viewModel: makeSubwaySearchViewModel())
    }

    func makeBusSearchViewController() -> BusSearchViewController {
        return BusSearchViewController(viewModel: makeBusSearchViewModel())
    }

}

private extension DIContainer {

    // MARK: - ViewModel

    private func makeSubwaySearchViewModel() -> SubwaySearchViewModel {
        return DefaultSubwaySearchViewModel(
            searchHistoryRepository: makeSearchHistoryRepository(),
            subwayRepository: makeLocalSubwayRepository()
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
        return LocalSubwayRepository.shared
    }

    private func makeLocalBusRepository() -> LocalBusRepository {
        return LocalBusRepository.shared
    }

}
