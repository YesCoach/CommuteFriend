//
//  HomeViewController.swift
//  CommuteFriend
//
//  Created by 박태현 on 2023/10/11.
//

import UIKit

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
            let subwaySearchViewController = DIContainer.shared.makeSubwaySearchViewController()
//            let subwaySearchViewController = TestSearchVC()
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
            let busSearchViewController = DIContainer.shared.makeBusSearchViewController()

            let navigationController = UINavigationController(
                rootViewController: busSearchViewController
            )
            present(navigationController, animated: true)
        }
        return view
    }()

    private lazy var titleLeftBarButtonItem: UIBarButtonItem = {
        let label = UILabel()
        label.text = "출퇴근메이트"
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .label

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
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }

        bottomView.snp.makeConstraints {
            $0.top.equalTo(homeArrivalView.snp.bottom).offset(30)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }

        [
            searchSelectionStackView
        ].forEach { bottomView.addSubview($0) }

        searchSelectionStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(30.0)
            $0.horizontalEdges.equalToSuperview()
        }

//        [
//            homeArrivalStackView, searchSelectionStackView
//        ].forEach { contentStackView.addArrangedSubview($0) }
//
//        [
//            subwaySelectionView, busSelectionView
//        ].forEach { view in
//            view.snp.makeConstraints {
//                $0.height.equalTo(view.snp.width)
//            }
//        }
    }

    override func configureNavigationItem() {
        super.configureNavigationItem()
        navigationItem.leftBarButtonItem = titleLeftBarButtonItem
        navigationItem.rightBarButtonItem = alarmBarButtonItem
    }

}

// MARK: - Private method

private extension HomeViewController {

    @objc func didAlarmButtonTouched(_ sender: UIButton) {
        sender.isSelected.toggle()
        // TODO: - User Notification 기능 구현
        print(#function)
    }

}
