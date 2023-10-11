//
//  SubwaySearchViewController.swift
//  CommuteFriend
//
//  Created by 박태현 on 2023/10/11.
//

import UIKit

final class SubwaySearchViewController: BaseViewController {

    // MARK: - UI

    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(
            searchResultsController: nil
        )
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.autocapitalizationType = .none
        searchController.searchBar.searchTextField.placeholder = "역 이름을 검색하세요."
        searchController.searchBar.returnKeyType = .search
        searchController.hidesNavigationBarDuringPresentation = false
        return searchController
    }()

    private lazy var emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "검색기록이 없어요!"
        label.isHidden = true
        return label
    }()

    override func configureUI() {
        super.configureUI()

        view.backgroundColor = .systemBackground
    }

    override func configureLayout() {
        super.configureLayout()

        [
            emptyLabel
        ].forEach { view.addSubview($0) }

        emptyLabel.snp.makeConstraints {
            $0.center.equalTo(view.safeAreaLayoutGuide)
        }
    }

    override func configureNavigationItem() {
        super.configureNavigationItem()
        navigationItem.searchController = searchController
        navigationItem.title = "지하철 검색"
        navigationItem.hidesSearchBarWhenScrolling = false
    }

}

// MARK: - SearchController Delegate

extension SubwaySearchViewController: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        // TODO: - 검색 로직
    }

}

extension SubwaySearchViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // TODO: - 검색 로직
        searchBar.resignFirstResponder()
    }

}
