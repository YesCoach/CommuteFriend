//
//  FavoriteViewController.swift
//  CommuteFriend
//
//  Created by 박태현 on 2023/10/16.
//

import UIKit

final class FavoriteViewController<T: StationTarget>: BaseViewController {

    typealias FavoriteItemType = FavoriteItem<T>

    private lazy var bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 30.0
        view.layer.cornerCurve = .continuous
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.layer.masksToBounds = true
        return view
    }()

    private lazy var titleView: UILabel = {
        let label = UILabel()
        label.text = "즐겨찾기"
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .white
        return label
    }()

    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.estimatedRowHeight = 40.0
        view.register(
            FavoriteStationCell.self,
            forCellReuseIdentifier: FavoriteStationCell.reuseIdentifier
        )
        return view
    }()

    private lazy var emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "등록된 즐겨찾기가 없어요."
        label.isHidden = true
        return label
    }()

    private lazy var enrollButton: UIButton = {
        var configuration = UIButton.Configuration
            .enrollButtonConfiguration(
                foregroundColor: .white,
                backgroundColor: .buttonColor
            )

        configuration.title = "추가하기"
        let button = UIButton()
        button.configuration = configuration

        return button
    }()

    private lazy var dataSource: UITableViewDiffableDataSource<Int, FavoriteItemType> = {
        let dataSource = UITableViewDiffableDataSource<Int, FavoriteItemType>(
            tableView: tableView
        ) { tableView, indexPath, itemIdentifier in
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: FavoriteStationCell.reuseIdentifier,
                for: indexPath
            ) as? FavoriteStationCell
            else { return UITableViewCell() }

            cell.configure(with: itemIdentifier)

            return cell
        }
        return dataSource
    }()

    override func configureUI() {
        super.configureUI()
        view.backgroundColor = .mainBackgroundColor
    }

    override func configureLayout() {
        super.configureLayout()
        [
            bottomView, tableView, enrollButton, emptyLabel
        ].forEach { view.addSubview($0) }

        bottomView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }

        tableView.snp.makeConstraints {
            $0.top.equalTo(bottomView.snp.top).inset(30.0)
            $0.horizontalEdges.equalTo(bottomView)
            $0.bottom.equalTo(enrollButton.snp.top)
        }

        enrollButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.horizontalEdges.equalToSuperview().inset(40)
        }

        emptyLabel.snp.makeConstraints {
            $0.center.equalTo(tableView)
        }
    }

    override func configureNavigationItem() {
        super.configureNavigationItem()
        navigationItem.titleView = titleView
    }

}

private extension FavoriteViewController {

    func updateSnapShot(data: [FavoriteItemType]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, FavoriteItemType>()

        snapshot.appendSections([1])
        snapshot.appendItems(data, toSection: 1)

        emptyLabel.isHidden = !data.isEmpty

        dataSource.apply(snapshot, animatingDifferences: true)
    }

}
