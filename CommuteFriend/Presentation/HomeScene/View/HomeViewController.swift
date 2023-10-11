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

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationItem()
    }

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
            homeArrivalView
        ].forEach { contentStackView.addArrangedSubview($0) }

    }

}

// MARK: - Private method

private extension HomeViewController {

    func configureNavigationItem() {
        navigationItem.leftBarButtonItem = titleLeftBarButtonItem
        navigationItem.rightBarButtonItem = settingBarButtonItem
    }

    @objc func didSettingButtonTouched(_ sender: UIBarButtonItem) {
        print(#function)
    }

}
