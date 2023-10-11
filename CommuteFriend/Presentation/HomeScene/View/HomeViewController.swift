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
        return scrollView
    }()

    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()

    private lazy var homeArrivalView: HomeArrivalView = {
        let view = HomeArrivalView()
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
            subwaySelectionView, busSelectionView
        ].forEach { stackView.addArrangedSubview($0) }

        return stackView
    }()

    private lazy var subwaySelectionView: SelectableView = {
        let view = SelectableView(selectableType: TransportationType.subway) { [weak self] _ in
            guard let self else { return }
            let subwaySearchViewController = SubwaySearchViewController()
            let navigationController = UINavigationController(
                rootViewController: subwaySearchViewController
            )
            present(navigationController, animated: true)
        }
        return view
    }()

    private lazy var busSelectionView: SelectableView = {
        let view = SelectableView(selectableType: TransportationType.bus) { type in
            print(type.description)
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

    private lazy var settingBarButtonItem: UIBarButtonItem = {
        let button = UIBarButtonItem(
            title: "설정",
            style: .plain,
            target: self,
            action: #selector(didSettingButtonTouched)
        )
        button.tintColor = .label
        return button
    }()

    // MARK: - Method

    override func configureUI() {
        super.configureUI()
        view.backgroundColor = .systemBackground
    }

    override func configureLayout() {
        super.configureLayout()

        [
            scrollView
        ].forEach { view.addSubview($0) }

        scrollView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }

        scrollView.addSubview(contentStackView)

        contentStackView.snp.makeConstraints {
            $0.edges.width.equalTo(scrollView)
        }

        [
            homeArrivalView, searchSelectionStackView
        ].forEach { contentStackView.addArrangedSubview($0) }

        [
            subwaySelectionView, busSelectionView
        ].forEach { view in
            view.snp.makeConstraints {
                $0.height.equalTo(view.snp.width)
            }
        }
    }

    override func configureNavigationItem() {
        super.configureNavigationItem()
        navigationItem.leftBarButtonItem = titleLeftBarButtonItem
        navigationItem.rightBarButtonItem = settingBarButtonItem
    }

}

// MARK: - Private method

private extension HomeViewController {

    @objc func didSettingButtonTouched(_ sender: UIBarButtonItem) {
        print(#function)
    }

}
