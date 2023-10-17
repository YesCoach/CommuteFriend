//
//  FavoriteViewController.swift
//  CommuteFriend
//
//  Created by 박태현 on 2023/10/16.
//

import UIKit
import RxSwift

final class FavoriteViewController<T: StationTarget>: BaseViewController, UITableViewDelegate {

    typealias FavoriteItemType = FavoriteItem<T>
    typealias DataSourceType = UITableViewDiffableDataSource<Int, FavoriteItemType>

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
        button.addTarget(self, action: #selector(didEnrollButtonTouched(_:)), for: .touchUpInside)

        return button
    }()

    private lazy var dataSource: DataSourceType = {
        let dataSource = DataSourceType(
            tableView: tableView
        ) { tableView, indexPath, itemIdentifier in
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: FavoriteStationCell.reuseIdentifier,
                for: indexPath
            ) as? FavoriteStationCell
            else { return UITableViewCell() }

            cell.configure(with: itemIdentifier)
            // TODO: - 1. 셀 터치시
//            cell.didAlarmButtonSelected = { [weak self] _ in
//                guard let self else { return }
//                viewModel.didAlarmButtonTouched(item: itemIdentifier)
//            }

            return cell
        }
        return dataSource
    }()

    private let viewModel: any FavoriteViewModel
    private let disposeBag = DisposeBag()

    init(viewModel: any FavoriteViewModel) {

        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel(viewModel: viewModel)
        enrollNotification()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewWillAppear()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(
            self,
            name: .favoriteUpdateNotification,
            object: nil
        )
    }

    deinit {
        deinitPrint()
    }

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

    @objc func didEnrollButtonTouched(_ sender: UIButton) {
        if T.self is SubwayTarget.Type {
            let searchViewController = DIContainer
                .shared
                .makeSubwaySearchViewController(beginningFrom: .favorite)
            let navigationController = UINavigationController(
                rootViewController: searchViewController
            )
            present(navigationController, animated: true)
        }
    }

    @objc func updateFavoriteItemList(_ sender: NSNotification) {
        viewModel.viewWillAppear()
    }

    // TODO: 2. 셀 스와이프시 삭제
//    func tableView(
//        _ tableView: UITableView,
//        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
//    ) -> UISwipeActionsConfiguration? {
//        guard let dataSource = tableView.dataSource as? DataSourceType,
//              let item = dataSource.itemIdentifier(for: indexPath)
//        else { return nil }
//
//        let action = UIContextualAction(
//            style: .destructive,
//            title: "삭제",
//            handler: { [weak self] (_, _, completionHandler) in
//                guard let self else { return }
//                viewModel.deleteFavoriteItem(item: item)
//                completionHandler(true)
//            }
//        )
//        return UISwipeActionsConfiguration(actions: [action])
//    }
}

private extension FavoriteViewController {

    func bindViewModel(viewModel: some FavoriteViewModel) {
        viewModel.favoriteStationItems
            .bind(with: self) { owner, list in
                if let castedList = list as? [FavoriteItemType] {
                    owner.updateSnapShot(data: castedList)
                }
            }
            .disposed(by: disposeBag)
    }

    func updateSnapShot(data: [FavoriteItemType]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, FavoriteItemType>()

        snapshot.appendSections([1])
        snapshot.appendItems(data, toSection: 1)

        emptyLabel.isHidden = !data.isEmpty

        dataSource.apply(snapshot, animatingDifferences: true)
    }

    func enrollNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateFavoriteItemList),
            name: .favoriteUpdateNotification,
            object: nil
        )
    }

}
