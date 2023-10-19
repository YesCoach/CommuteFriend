//
//  BusRouteSearchDetailViewController.swift
//  CommuteFriend
//
//  Created by 박태현 on 2023/10/18.
//

import UIKit
import RxSwift

final class BusRouteSearchDetailViewController: BaseViewController {

    typealias DataSoureType = UICollectionViewDiffableDataSource<Int, BusStation>
    typealias SnapshotType = NSDiffableDataSourceSnapshot<Int, BusStation>
    typealias CellRegistrationType = UICollectionView
        .CellRegistration<BusRouteSearchDetailCell, BusStation>

    // MARK: - UI Components

    private lazy var collectionView: UICollectionView = {
        let layout = createLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.keyboardDismissMode = .onDrag
        collectionView.delegate = self
        return collectionView
    }()

    private lazy var dataSource: DataSoureType = {
        let cellRegistration = createCellRegistration()
        let dataSource = DataSoureType(
            collectionView: collectionView
        ) { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(
                using: cellRegistration,
                for: indexPath,
                item: itemIdentifier
            )
            return cell
        }
        return dataSource
    }()

    private let viewModel: BusRouteSearchDetailViewModel
    private let disposeBag = DisposeBag()

    // MARK: - Initializer

    init(viewModel: BusRouteSearchDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        deinitPrint()
    }

    // MARK: - LifeCycle

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
        navigationItem.title = viewModel.bus.name
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

private extension BusRouteSearchDetailViewController {

    func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(
            top: 10,
            leading: 20,
            bottom: 10,
            trailing: 20
        )

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(0.1)
        )
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)

        let layout = UICollectionViewCompositionalLayout(section: section)

        return layout
    }

    func createCellRegistration() -> CellRegistrationType {
        let cellRegistration = CellRegistrationType { cell, _, itemIdentifier in
            cell.configure(with: itemIdentifier)
        }

        return cellRegistration
    }

    func updateSnapshot(data: [BusStation]) {
        var snapshot = SnapshotType()

        snapshot.appendSections([1])
        snapshot.appendItems(data, toSection: 1)

        dataSource.apply(snapshot, animatingDifferences: true)
    }

    func bindViewModel() {
        viewModel.busStationList
            .observe(on: MainScheduler.instance)
            .subscribe(with: self) { owner, list in
                owner.updateSnapshot(data: list)
            }
            .disposed(by: disposeBag)
    }

}

// MARK: - UICollectionViewDelegate

extension BusRouteSearchDetailViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
        viewModel.didSelectItemAt(item: item)
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }

}
