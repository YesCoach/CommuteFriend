//
//  RecentStationView.swift
//  CommuteFriend
//
//  Created by 박태현 on 2023/10/15.
//

import UIKit

final class RecentStationView<T: StationTarget>: UIView {

    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(
            RecentStationCell.self,
            forCellReuseIdentifier: RecentStationCell.reuseIdentifier
        )
        tableView.backgroundColor = .systemGray6
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 44.0
        return tableView
    }()

    private lazy var emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "최근 기록이 없어요"
        label.textColor = .gray
        return label
    }()

    lazy var dataSource: UITableViewDiffableDataSource<Int, T> = {
        let dataSource = UITableViewDiffableDataSource<Int, T>(
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

    func updateSnapShot(data: [T]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, T>()

        snapshot.appendSections([1])
        snapshot.appendItems(data, toSection: 1)

        emptyLabel.isHidden = !data.isEmpty

        dataSource.apply(snapshot, animatingDifferences: false) { [weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [self] in
                self?.tableView.setContentOffset(.init(x: 0, y: 0), animated: true)
            }
        }
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
