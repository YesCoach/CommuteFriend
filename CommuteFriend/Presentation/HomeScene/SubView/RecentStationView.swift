//
//  RecentStationView.swift
//  CommuteFriend
//
//  Created by 박태현 on 2023/10/15.
//

import UIKit

final class RecentStationView: UIView {

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(
            RecentStationCell.self,
            forCellReuseIdentifier: RecentStationCell.reuseIdentifier
        )
        tableView.backgroundColor = .systemGray6
        return tableView
    }()

    private lazy var emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "최근 기록이 없어요"
        label.textColor = .gray
        return label
    }()

    lazy var dataSource: UITableViewDiffableDataSource<Int, SubwayTarget> = {
        let dataSource = UITableViewDiffableDataSource<Int, SubwayTarget>(
            tableView: tableView
        ) { tableView, indexPath, itemIdentifier in
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: RecentStationCell.reuseIdentifier,
                for: indexPath
            ) as? RecentStationCell
            else { return UITableViewCell() }

            cell.configure(with: itemIdentifier)

            return cell
        }
        return dataSource
    }()

    // MARK: - Initializer

    init() {
        super.init(frame: .zero)
        configureUI()
        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateSnapShot(data: [SubwayTarget]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, SubwayTarget>()

        snapshot.appendSections([1])
        snapshot.appendItems(data, toSection: 1)

        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

// MARK: - Private Methods

private extension RecentStationView {

    func configureUI() {
        layer.cornerRadius = 15.0
        layer.masksToBounds = true
        layer.cornerCurve = .continuous
        backgroundColor = .systemGray6
    }

    func configureLayout() {
        [
            tableView, emptyLabel
        ].forEach { addSubview($0) }

        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        emptyLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }

}
