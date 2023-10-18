//
//  HomeViewController.swift
//  CommuteFriend
//
//  Created by 박태현 on 2023/10/11.
//

import UIKit
import RxSwift

final class HomeViewController: BaseViewController {

    // MARK: - View

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.contentInset = .init(top: 10.0, left: 0, bottom: 0, right: 0)
        return scrollView
    }()

    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20.0
        return stackView
    }()

    private lazy var homeArrivalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.layoutMargins = .init(top: 0, left: 20, bottom: 0, right: 20)
        stackView.isLayoutMarginsRelativeArrangement = true

        stackView.addArrangedSubview(homeArrivalView)
        return stackView
    }()

    private lazy var homeArrivalView: HomeArrivalView = {
        let view = HomeArrivalView()
        return view
    }()

    private lazy var bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 30.0
        view.layer.cornerCurve = .continuous
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.layer.masksToBounds = true
        return view
    }()

    private lazy var searchSelectionStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 20.0
        stackView.distribution = .fillEqually
        stackView.layoutMargins = .init(top: 0, left: 20, bottom: 0, right: 20)
        stackView.isLayoutMarginsRelativeArrangement = true

        [
            subwaySelectionView, favoriteSelectionView
        ].forEach { stackView.addArrangedSubview($0) }

        return stackView
    }()

    private lazy var subwaySelectionView: MenuSelectableView = {
        let view = MenuSelectableView(
            menuType: .subway
        ) { [weak self] _ in
            guard let self else { return }
            let subwaySearchViewController = DIContainer
                .shared
                .makeSubwaySearchViewController(beginningFrom: .home)
            let navigationController = UINavigationController(
                rootViewController: subwaySearchViewController
            )
            present(navigationController, animated: true)
        }
        return view
    }()

    private lazy var favoriteSelectionView: MenuSelectableView = {
        let view = MenuSelectableView(
            menuType: .favorite
        ) { [weak self] _ in
            guard let self else { return }
            let favoriteViewController = DIContainer.shared.makeSubwayFavoriteViewController()

            favoriteViewController.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(favoriteViewController, animated: true)
        }
        return view
    }()

    private lazy var recentStationView: RecentStationView = {
        let view = RecentStationView<SubwayTarget>()
        view.tableView.delegate = self
        return view
    }()

    private lazy var titleLeftBarButtonItem: UIBarButtonItem = {
        let label = UILabel()
        label.text = "지하철메이트"
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .white

        let barButtonItem = UIBarButtonItem(customView: label)
        return barButtonItem
    }()

    private lazy var alarmBarButtonItem: UIBarButtonItem = {
        let button = UIButton()
        button.setImage(.init(systemName: "bell.fill"), for: .normal)
        button.setImage(.init(systemName: "bell.slash.fill"), for: .selected)
        button.addTarget(
            self,
            action: #selector(didAlarmButtonTouched(_:)),
            for: .touchUpInside
        )
        let buttonItem = UIBarButtonItem(customView: button)
        return buttonItem
    }()

    // MARK: - Property

    private let viewModel: HomeViewModel
    private let disposeBag = DisposeBag()

    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        bindViewModel()
        enrollNotification()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewWillAppear()
    }

    // MARK: - Method

    override func configureUI() {
        super.configureUI()
        view.backgroundColor = .mainBackgroundColor
    }

    override func configureLayout() {
        super.configureLayout()

        [
            homeArrivalView, bottomView
        ].forEach { view.addSubview($0) }

        homeArrivalView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
        }

        bottomView.snp.makeConstraints {
            $0.top.equalTo(homeArrivalView.snp.bottom).offset(30)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }

        [
            searchSelectionStackView, recentStationView
        ].forEach { bottomView.addSubview($0) }

        searchSelectionStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(30.0)
            $0.horizontalEdges.equalToSuperview()
        }

        recentStationView.snp.makeConstraints {
            $0.top.equalTo(searchSelectionStackView.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(5)
        }
    }

    override func configureNavigationItem() {
        super.configureNavigationItem()
        navigationItem.leftBarButtonItem = titleLeftBarButtonItem
        navigationItem.rightBarButtonItem = alarmBarButtonItem
        navigationItem.backButtonTitle = ""
    }

    private func configureNavigationBar() {
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
    }

}

// MARK: - Private method

private extension HomeViewController {

    func bindViewModel() {
        viewModel
            .recentSubwayStationList
            .subscribe(with: self) { owner, stationList in
                owner.recentStationView.updateSnapShot(data: stationList)
            }
            .disposed(by: disposeBag)
        viewModel
            .currentSubwayStationArrival
            .bind(with: self) { owner, stationArrivalResponse in
                owner.homeArrivalView.configure(with: stationArrivalResponse)
            }
            .disposed(by: disposeBag)
    }

    func enrollNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateCurrentStationArrival),
            name: .homeUpdateNotification,
            object: nil
        )
    }

    @objc func updateCurrentStationArrival() {
        viewModel.viewWillAppear()
    }

    @objc func didAlarmButtonTouched(_ sender: UIButton) {
        sender.isSelected.toggle()
        // TODO: - User Notification 기능 구현
        print(#function)
    }

}

// MARK: - RecentStationView TableViewDelegate

extension HomeViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let item = recentStationView.dataSource.itemIdentifier(for: indexPath)
        else { return }

        viewModel.didSelectRowAt(subwayTarget: item)
    }

    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        guard let item = recentStationView.dataSource.itemIdentifier(for: indexPath)
        else { return nil }

        let action = UIContextualAction(
            style: .destructive,
            title: "삭제",
            handler: { [weak self] (_, _, completionHandler) in
                guard let self else { return }
                viewModel.removeRecentSearchItem(with: item)
                completionHandler(true)
            }
        )
        return UISwipeActionsConfiguration(actions: [action])
    }

}
