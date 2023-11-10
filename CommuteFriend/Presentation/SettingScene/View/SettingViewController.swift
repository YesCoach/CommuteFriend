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
        let tableView = UITableView(frame: .zero, style: .grouped)
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

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let subwayTrain = UIImageView(image: .init(systemName: "train.side.front.car"))
        subwayTrain.frame = CGRect(x: -100, y: 100, width: 50, height: 25)
        subwayTrain.tintColor = .systemRed
        view.addSubview(subwayTrain)

        UIView.animate(withDuration: 3.0, delay: 0, options: .repeat) {
            subwayTrain.frame.origin.x = self.view.frame.size.width
        } completion: { bool in
            print("Ani Complet")
        }
    }

    override func configureUI() {
        super.configureUI()
        view.backgroundColor = .systemBackground
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
