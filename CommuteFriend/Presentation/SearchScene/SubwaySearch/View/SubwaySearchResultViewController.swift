//
//  SubwaySearchResultViewController.swift
//  CommuteFriend
//
//  Created by 박태현 on 2023/10/12.
//

import UIKit

final class SubwaySearchResultViewController: BaseViewController {

    typealias DataSourceType = UITableViewDiffableDataSource<Int, SubwayStation>
    typealias SnapshotType = NSDiffableDataSourceSnapshot<Int, SubwayStation>

    // MARK: - View

    private lazy var searchResultTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(
            SubwaySearchResultCell.self,
            forCellReuseIdentifier: SubwaySearchResultCell.reuseIdentifier
        )
        tableView.estimatedRowHeight = 40.0
        tableView.keyboardDismissMode = .onDrag
        tableView.delegate = self
        return tableView
    }()

    var itemSelectHandler: ((SubwayStation) -> Void)?

    private var dataSource: DataSourceType?

    deinit {
        deinitPrint()
    }

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

    func updateSnapshot(data: [SubwayStation]) {
        var snapshot = SnapshotType()

        snapshot.appendSections([1])
        snapshot.appendItems(data, toSection: 1)

        guard let dataSource else { return }
        dataSource.apply(snapshot, animatingDifferences: false)
    }

}

extension SubwaySearchResultViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let dataSource,
              let item = dataSource.itemIdentifier(for: indexPath)
        else { return }
        itemSelectHandler?(item)
    }

}

private extension SubwaySearchResultViewController {

    func configureDataSource() {
        dataSource = DataSourceType(
            tableView: searchResultTableView,
            cellProvider: { tableView, _, itemIdentifier in
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: SubwaySearchResultCell.reuseIdentifier
                ) as? SubwaySearchResultCell
                else { return UITableViewCell() }

                cell.configure(with: itemIdentifier)
                return cell
            }
        )
    }

}
