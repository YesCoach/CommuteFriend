//
//  BusSearchViewController.swift
//  CommuteFriend
//
//  Created by 박태현 on 2023/10/12.
//

import UIKit
import RxSwift
import RxCocoa

final class BusSearchViewController: BaseViewController {

    typealias DataSourceType = UITableViewDiffableDataSource<Int, String>
    typealias SnapshotType = NSDiffableDataSourceSnapshot<Int, String>

    enum BeginningFrom {
        case home
        case favorite
    }

    // MARK: - UI

    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(
            searchResultsController: searchResultViewController
        )
        searchController.searchBar.autocapitalizationType = .none
        searchController.searchBar.searchTextField.placeholder = "버스 노선을 검색하세요."
        searchController.searchBar.returnKeyType = .search
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.scopeButtonTitles = ["버스", "정류장"]
        searchController.searchBar.showsScopeBar = true
        searchController.searchBar.searchTextField.adjustsFontSizeToFitWidth = true
        searchController.searchBar.setScopeBarButtonTitleTextAttributes([
            .font: UIFont.preferredFont(forTextStyle: .headline)
        ], for: .normal)
        return searchController
    }()

    private lazy var searchResultViewController: BusSearchResultViewController = {
        let viewController = BusSearchResultViewController(nibName: nil, bundle: nil)
        viewController.itemSelectHandler = { [weak self] item in
            guard let self else { return }
            if let item = item as? BusStation {
                viewModel.didSelectItem(of: item)
                let detailViewController = DIContainer
                    .shared
                    .makeBusStationSearchDetailViewController(
                        busStation: item,
                        beginningFrom: beginningFrom
                    )
                navigationController?.pushViewController(detailViewController, animated: true)
            }
            if let item = item as? Bus {
                viewModel.didSelectItem(of: item)
                let detailViewControllr = DIContainer
                    .shared
                    .makeBusRouteSearchDetailViewController(
                        bus: item,
                        beginningFrom: beginningFrom
                    )
                navigationController?.pushViewController(detailViewControllr, animated: true)
            }
        }
        return viewController
    }()

    private lazy var searchHistoryTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(
            SearchHistoryCell.self,
            forCellReuseIdentifier: SearchHistoryCell.reuseIdentifier
        )
        tableView.register(
            SearchHistoryHeaderView.self,
            forHeaderFooterViewReuseIdentifier: SearchHistoryHeaderView.reuseIdentifier
        )

        tableView.estimatedRowHeight = 40.0
        tableView.delegate = self
        return tableView
    }()

    private lazy var emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "검색기록이 없어요!"
        label.isHidden = true
        return label
    }()

    // MARK: - Property

    private let viewModel: BusSearchViewModel
    private var dataSource: DataSourceType?
    private let disposeBag = DisposeBag()

    private let beginningFrom: BeginningFrom

    // MARK: - Init

    init(viewModel: BusSearchViewModel, beginningFrom: BeginningFrom) {
        self.viewModel = viewModel
        self.beginningFrom = beginningFrom
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        searchController.isActive = false
    }

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureDataSource()
        bindViewModel()
        viewModel.viewDidLoad()
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
        navigationItem.title = "버스 검색"
        navigationItem.hidesSearchBarWhenScrolling = false
    }

}

// MARK: - Private Method

private extension BusSearchViewController {

    func bindViewModel() {

        searchController.searchBar.searchTextField.rx.text.orEmpty
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .bind(with: self) { owner, text in
                owner.viewModel.updateSearchResults(with: text)
            }
            .disposed(by: disposeBag)

        searchController.searchBar.rx.searchButtonClicked
            .bind(with: self) { owner, _ in
                owner.viewModel.searchButtonClicked(with: owner.searchController.searchBar.text!)
                owner.searchController.searchBar.resignFirstResponder()
            }
            .disposed(by: disposeBag)

        searchController.searchBar.rx.selectedScopeButtonIndex
            .bind(with: self) { owner, index in
                owner.viewModel.didSegmentControlValueChanged(
                    index: index,
                    keyword: owner.searchController.searchBar.text
                )
                let placeholderText = (index == 0 ? "버스 노선을 검색하세요." : "정류장 이름을 검색하세요.")
                owner.searchController.searchBar.placeholder = placeholderText
            }
            .disposed(by: disposeBag)

        viewModel.searchBusStationResult
            .subscribe(with: self) { owner, list in
                owner.searchResultViewController.updateSnapshot(data: list)
            }
            .disposed(by: disposeBag)

        viewModel.searchBusResult
            .subscribe(with: self) { owner, list in
                owner.searchResultViewController.updateSnapshot(data: list)
            }
            .disposed(by: disposeBag)

        viewModel.searchHistoryList
            .subscribe(with: self) { owner, list in
                owner.emptyLabel.isHidden = !list.isEmpty
                owner.updateSearchHistorySnapShot(data: list)
            }
            .disposed(by: disposeBag)

        viewModel.searchKeyword
            .asDriver()
            .drive(with: self) { owner, text in
                owner.searchController.searchBar.text = text
                owner.searchController.searchBar.becomeFirstResponder()
            }
            .disposed(by: disposeBag)
    }

    func configureDataSource() {
        dataSource = DataSourceType(
            tableView: searchHistoryTableView,
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
    }

    func updateSearchHistorySnapShot(data: [String]) {
        var snapshot = SnapshotType()

        snapshot.appendSections([1])
        snapshot.appendItems(data, toSection: 1)

        guard let dataSource else { return }
        dataSource.apply(snapshot, animatingDifferences: false)
    }

}

// MARK: - TableViewDelegate

extension BusSearchViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let data = dataSource?.itemIdentifier(for: indexPath) else { return }
        viewModel.didSelectSearchHistoryItem(of: data)
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: SearchHistoryHeaderView.reuseIdentifier
        ) as? SearchHistoryHeaderView
        else { return UIView() }

        header.deleteButtonHandler = { [weak self] in
            guard let self else { return }
            viewModel.clearSearchHistory()
        }
        return header
    }

    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        guard let itemIdentifier = dataSource?.itemIdentifier(for: indexPath)
        else { return nil }

        let action = UIContextualAction(
            style: .destructive,
            title: "삭제",
            handler: { [weak self] (_, _, completionHandler) in
                guard let self else { return }
                viewModel.removeSearchHistory(text: itemIdentifier)
                completionHandler(true)
            }
        )

        return UISwipeActionsConfiguration(actions: [action])
    }

}
