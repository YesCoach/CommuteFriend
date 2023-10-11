//
//  SubwaySearchViewController.swift
//  CommuteFriend
//
//  Created by 박태현 on 2023/10/11.
//

import UIKit

final class SubwaySearchViewController: BaseViewController {

    typealias DataSourceType = UITableViewDiffableDataSource<Int, String>

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

    private lazy var searchHistoryTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(
            SearchHistoryCell.self,
            forCellReuseIdentifier: SearchHistoryCell.reuseIdentifier
        )
        dataSource = DataSourceType(
            tableView: tableView,
            cellProvider: { tableView, indexPath, itemIdentifier in
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: SearchHistoryCell.reuseIdentifier,
                    for: indexPath
                ) as? SearchHistoryCell
                else { return UITableViewCell() }

                cell.configure(with: itemIdentifier)
                return cell
            }
        )
        tableView.dataSource = dataSource
        return tableView
    }()

    private lazy var emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "검색기록이 없어요!"
        label.isHidden = true
        return label
    }()

    // MARK: - Property

    private var dataSource: DataSourceType?

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func configureUI() {
        super.configureUI()
        view.backgroundColor = .systemBackground
    }

    override func configureLayout() {
        super.configureLayout()

        [
            searchHistoryTableView, emptyLabel
        ].forEach { view.addSubview($0) }

        searchHistoryTableView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }

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
