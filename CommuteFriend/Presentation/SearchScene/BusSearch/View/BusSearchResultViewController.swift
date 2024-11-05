//
//  BusSearchResultViewController.swift
//  CommuteFriend
//
//  Created by 박태현 on 2023/10/12.
//

import UIKit
import RxSwift
import RxCocoa

final class BusSearchResultViewController: BaseViewController {

    // TODO: - AnyHashable 개선하기

    typealias DataSourceType = UITableViewDiffableDataSource<Int, AnyHashable>
    typealias SnapshotType = NSDiffableDataSourceSnapshot<Int, AnyHashable>

    // MARK: - View

    private lazy var searchResultTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(
            BusStationSearchResultCell.self,
            forCellReuseIdentifier: BusStationSearchResultCell.reuseIdentifier
        )
        tableView.register(
            BusSearchResultCell.self,
            forCellReuseIdentifier: BusSearchResultCell.reuseIdentifier
        )
        tableView.estimatedRowHeight = 40.0
        tableView.keyboardDismissMode = .onDrag

        tableView.rx.itemSelected
            .bind(with: self) { owner, indexPath in
                guard let item = owner.dataSource?.itemIdentifier(for: indexPath) else { return }
                owner.itemSelectHandler?(item)
            }
            .disposed(by: disposeBag)

        return tableView
    }()

    var itemSelectHandler: ((AnyHashable) -> Void)?

    private var dataSource: DataSourceType?
    private let disposeBag = DisposeBag()

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureDataSource()
    }

    override func configureLayout() {
        super.configureLayout()

        view.addSubview(searchResultTableView)

        searchResultTableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    func updateSnapshot(data: [AnyHashable]) {
        var snapshot = SnapshotType()

        snapshot.appendSections([1])
        snapshot.appendItems(data, toSection: 1)

        guard let dataSource else { return }
        dataSource.applySnapshotUsingReloadData(snapshot)
    }

}

private extension BusSearchResultViewController {

    func configureDataSource() {
        dataSource = DataSourceType(
            tableView: searchResultTableView,
            cellProvider: { tableView, _, itemIdentifier in
                switch itemIdentifier {
                case let item as BusStation:
                    guard let cell = tableView.dequeueReusableCell(
                        withIdentifier: BusStationSearchResultCell.reuseIdentifier
                    ) as? BusStationSearchResultCell
                    else { return UITableViewCell() }

                    cell.configure(with: item)
                    return cell

                case let item as Bus:
                    guard let cell = tableView.dequeueReusableCell(
                        withIdentifier: BusSearchResultCell.reuseIdentifier
                    ) as? BusSearchResultCell
                    else { return UITableViewCell() }

                    cell.configure(with: item)
                    return cell
                default: return UITableViewCell()
                }
            }
        )
    }

}
