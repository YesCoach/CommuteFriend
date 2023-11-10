//
//  SettingViewController.swift
//  CommuteFriend
//
//  Created by 박태현 on 2023/10/22.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

final class SettingViewController: BaseViewController {

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.register(
            SettingViewCell.self,
            forCellReuseIdentifier: SettingViewCell.reuseIdentifier
        )
        tableView.estimatedRowHeight = .zero
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()

    private lazy var dataSource: RxTableViewSectionedReloadDataSource<Setting> = {
        let dataSource = RxTableViewSectionedReloadDataSource<Setting> {
            datasource, tableView, indexPath, item in
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: SettingViewCell.reuseIdentifier,
                for: indexPath
            ) as? SettingViewCell else { return UITableViewCell() }
            cell.configure(with: item)
            return cell
        }

        dataSource.titleForHeaderInSection = { dataSource, index in
          return dataSource.sectionModels[index].header
        }

        return dataSource
    }()

    private let viewModel: SettingViewModel
    private let disposeBag = DisposeBag()

    // MARK: - Init

    init(viewModel: SettingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }

    override func configureUI() {
        super.configureUI()
        view.backgroundColor = .mainBackgroundColor
    }

    override func configureLayout() {
        super.configureLayout()
        [
            tableView
        ].forEach { view.addSubview($0) }

        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    override func configureNavigationItem() {
        super.configureNavigationItem()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .automatic
        navigationItem.title = "설정"
    }

    // MARK: - Methods

    private func bind() {
        let cellSelected: ControlEvent<IndexPath> = tableView.rx.itemSelected

        let input = SettingViewModel.Input(cellSelected: cellSelected.asObservable())
        let output = viewModel.transform(from: input)
        output.settingItems
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        output.selectedItem
            .bind(with: self) { owner, item in
                print(item.description)
            }
            .disposed(by: disposeBag)
    }

}
