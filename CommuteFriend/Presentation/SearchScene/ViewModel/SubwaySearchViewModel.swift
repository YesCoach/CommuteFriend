//
//  SubwaySearchViewModel.swift
//  CommuteFriend
//
//  Created by 박태현 on 2023/10/12.
//

import Foundation
import RxSwift
import RxRelay
import RxCocoa

protocol SubwaySearchViewModelInput {
    func viewDidLoad()
    func searchButtonClicked(with text: String)
    func didSelectSearchHistoryItem(of text: String)
    func addSearchHistory(text: String)
    func removeSearchHistory(text: String)
    func clearSearchHistory()
}

protocol SubwaySearchViewModelOutput {
    var searchHistoryList: BehaviorSubject<[String]> { get }
    var searchKeyword: BehaviorRelay<String> { get }
}

protocol SubwaySearchViewModel: SubwaySearchViewModelInput, SubwaySearchViewModelOutput { }

final class DefaultSubwaySearchViewModel: SubwaySearchViewModel {

    private let searchHistoryRepository: SearchHistoryRepository

    init(
        searchHistoryRepository: SearchHistoryRepository
    ) {
        self.searchHistoryRepository = searchHistoryRepository
    }

    deinit {
        print("🗑️: \(String(describing: type(of: self))) deinit!")
    }

    // MARK: - SubwaySearchViewModelOutput

    let searchHistoryList: BehaviorSubject<[String]> = BehaviorSubject(value: [])
    let searchKeyword: BehaviorRelay<String> = BehaviorRelay(value: "")

}

// MARK: - SubwaySearchViewModelInput

extension DefaultSubwaySearchViewModel {

    func viewDidLoad() {
        loadSearchHistory()
    }

    func searchButtonClicked(with text: String) {
        addSearchHistory(text: text)
    }

    func didSelectSearchHistoryItem(of text: String) {
        searchKeyword.accept(text)
        addSearchHistory(text: text)
    }

    /// 검색 기록을 추가합니다.
    func addSearchHistory(text: String) {
        let trimmedText = text.trimmingCharacters(in: [" "])

        guard var searchHistoryListValue = try? searchHistoryList.value() else { return }
        guard trimmedText.isEmpty == false else { return }

        if let index = searchHistoryListValue.firstIndex(of: trimmedText) {
            searchHistoryListValue.remove(at: index)
        }
        searchHistoryListValue.insert(trimmedText, at: 0)
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

private extension DefaultSubwaySearchViewModel {

    // MARK: - search history save/load

    /// UserDefaults에 검색기록을 저장합니다.
    private func saveSearchHistory() {
        guard let searchHistoryListValue = try? searchHistoryList.value() else { return }
        searchHistoryRepository.saveSearchHistoryList(
            historyList: searchHistoryListValue,
            type: .subway
        )
    }

    /// UserDefaults로부터 검색기록을 불러옵니다.
    private func loadSearchHistory() {
        searchHistoryList.onNext(searchHistoryRepository.loadSearchHistoryList(type: .subway))
    }

}
