//
//  BusSearchViewModel.swift
//  CommuteFriend
//
//  Created by 박태현 on 2023/10/12.
//

import Foundation
import RxSwift
import RxRelay
import RxCocoa

protocol BusSearchViewModelInput {
    func viewDidLoad()
    func updateSearchResults(with keyword: String)
    func searchButtonClicked(with text: String)
    func didSelectItem(of item: any BusSearchable)
    func didSegmentControlValueChanged(index: Int, keyword: String?)
    func didSelectSearchHistoryItem(of item: String)
    func addSearchHistory(text: String)
    func removeSearchHistory(text: String)
    func clearSearchHistory()
}

protocol BusSearchViewModelOutput {
    var searchBusStationResult: BehaviorSubject<[BusStation]> { get }
    var searchBusResult: BehaviorSubject<[Bus]> { get }
    var searchHistoryList: BehaviorSubject<[String]> { get }
    var searchKeyword: BehaviorRelay<String> { get }
}

protocol BusSearchViewModel: BusSearchViewModelInput, BusSearchViewModelOutput { }

final class DefaultBusSearchViewModel: BusSearchViewModel {

    private let searchHistoryRepository: SearchHistoryRepository
    private let localBusRepository: LocalBusRepository
    private let busRepository: BusRepository

    private var segmentIndex: Int = 0
    private var searchHistoryType: SearchHistoryType {
        segmentIndex == 0 ? .busByRoute: .busByStation
    }

    init(
        searchHistoryRepository: SearchHistoryRepository,
        localBusRepository: LocalBusRepository,
        busRepository: BusRepository
    ) {
        self.searchHistoryRepository = searchHistoryRepository
        self.localBusRepository = localBusRepository
        self.busRepository = busRepository
    }

    deinit {
        print("🗑️ - \(String(describing: type(of: self)))")
    }

    let searchBusStationResult: BehaviorSubject<[BusStation]> = BehaviorSubject(value: [])
    let searchBusResult: BehaviorSubject<[Bus]> = BehaviorSubject(value: [])
    let searchHistoryList: BehaviorSubject<[String]> = BehaviorSubject(value: [])
    let searchKeyword: BehaviorRelay<String> = BehaviorRelay(value: "")
}

// MARK: - BusSearchViewModelInput

extension DefaultBusSearchViewModel {

    func viewDidLoad() {
        loadSearchHistory()
    }

    func updateSearchResults(with keyword: String) {
        guard keyword.isEmpty == false else {
            if segmentIndex == 0 {
                searchBusResult.onNext([])
            } else {
                searchBusStationResult.onNext([])
            }
            return
        }
        if segmentIndex == 0 {
            busRepository.fetch(
                keyword: keyword
            ) { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let list):
                    searchBusResult.onNext(list)
                case .failure(let error):
                    print(error)
                }
            }
        }
        if segmentIndex == 1 {
            guard let data = localBusRepository.fetchStationByName(name: keyword) else { return }
            searchBusStationResult.onNext(data)
        }
    }

    func searchButtonClicked(with text: String) {
        addSearchHistory(text: text)
    }

    func didSelectItem(of item: any BusSearchable) {
        addSearchHistory(text: item.name)
    }

    func didSegmentControlValueChanged(index: Int, keyword: String? = nil) {
        self.segmentIndex = index
        searchBusResult.onNext([])
        searchBusStationResult.onNext([])
        loadSearchHistory()

        if let keyword { updateSearchResults(with: keyword) }
    }

    func didSelectSearchHistoryItem(of text: String) {
        searchKeyword.accept(text)
        addSearchHistory(text: text)
        updateSearchResults(with: text)
    }

    /// 검색 기록을 추가합니다.
    func addSearchHistory(text: String) {
        guard var searchHistoryListValue = try? searchHistoryList.value() else { return }
        if let index = searchHistoryListValue.firstIndex(of: text) {
            searchHistoryListValue.remove(at: index)
        }
        searchHistoryListValue.insert(text, at: 0)
        searchHistoryList.onNext(searchHistoryListValue)
        saveSearchHistory()
    }

    /// 검색 기록을 삭제합니다.
    func removeSearchHistory(text: String) {
        guard var searchHistoryListValue = try? searchHistoryList.value() else { return }
        if let index = searchHistoryListValue.firstIndex(of: text) {
            searchHistoryListValue.remove(at: index)
        }
        searchHistoryList.onNext(searchHistoryListValue)
        saveSearchHistory()
    }

    /// 검색 기록을 초기화합니다.
    func clearSearchHistory() {
        searchHistoryList.onNext([])
        saveSearchHistory()
    }

}

// MARK: - Private Methods

private extension DefaultBusSearchViewModel {

    // MARK: - search history save/load

    /// UserDefaults에 검색기록을 저장합니다.
    private func saveSearchHistory() {
        guard let searchHistoryListValue = try? searchHistoryList.value() else { return }
        searchHistoryRepository.saveSearchHistoryList(
            historyList: searchHistoryListValue,
            type: searchHistoryType
        )
    }

    /// UserDefaults로부터 검색기록을 불러옵니다.
    private func loadSearchHistory() {
        searchHistoryList.onNext(
            searchHistoryRepository.loadSearchHistoryList(type: searchHistoryType)
        )
    }
}
