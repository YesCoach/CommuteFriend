//
//  BusSearchDetailViewController.swift
//  CommuteFriend
//
//  Created by 박태현 on 2023/10/18.
//

import UIKit
import RxSwift

final class BusStationSearchDetailViewController: BaseViewController {

    typealias DataSourceType = UICollectionViewDiffableDataSource<Int, BusArrival>
    typealias SnapshotType = NSDiffableDataSourceSnapshot<Int, BusArrival>
    typealias CellRegistrationType = UICollectionView
        .CellRegistration<BusStationSearchDetailCell, BusArrival>

    // MARK: - UI Components

    private lazy var collectionView: UICollectionView = {
        let layout = createLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(
            BusStationSearchDetailCell.self,
            forCellWithReuseIdentifier: BusStationSearchDetailCell.reuseIdentifier
        )
        collectionView.keyboardDismissMode = .onDrag
        collectionView.delegate = self
        return collectionView
    }()

    private lazy var dataSource: DataSourceType = {
        let dataSource = DataSourceType(
            collectionView: collectionView
        ) { collectionView, indexPath, itemIdentifier in
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: BusStationSearchDetailCell.reuseIdentifier,
                for: indexPath
            ) as? BusStationSearchDetailCell else { return UICollectionViewCell() }
            cell.configure(with: itemIdentifier)
            return cell
        }
        return dataSource
    }()

    private let viewModel: BusStationSearchDetailViewModel
    private let disposeBag = DisposeBag()

    // MARK: - Initializer

    init(viewModel: BusStationSearchDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - LifeCycle

    deinit {
        deinitPrint()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewWillAppear()
    }

    // MARK: - Methods

    override func configureUI() {
        super.configureUI()

        navigationItem.largeTitleDisplayMode = .always
        navigationItem.title = viewModel.busStation.name
    }

    override func configureLayout() {
        super.configureLayout()
        view.addSubview(collectionView)

        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

}

// MARK: - Private Methods

private extension BusStationSearchDetailViewController {

    func bindViewModel() {
        viewModel.busRouteItems
            .observe(on: MainScheduler.instance)
            .subscribe(with: self) { owner, list in
                owner.updateSnapshot(data: list)
            }
            .disposed(by: disposeBag)
    }

    func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(100)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(100)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 1)
        group.contentInsets = .init(top: 20, leading: 10, bottom: 10, trailing: 10)

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 20.0
        let layout = UICollectionViewCompositionalLayout(section: section)

        return layout
    }

    func updateSnapshot(data: [BusArrival]) {
        var snapshot = SnapshotType()

        snapshot.appendSections([1])
        snapshot.appendItems(data, toSection: 1)

        dataSource.apply(snapshot, animatingDifferences: true)
    }

}

// MARK: - UICollectionViewDelegate

extension BusStationSearchDetailViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
        viewModel.didSelectItemAt(item: item)
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
}
