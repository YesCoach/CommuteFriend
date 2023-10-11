//
//  HomeViewController.swift
//  CommuteFriend
//
//  Created by 박태현 on 2023/10/11.
//

import UIKit

final class HomeViewController: BaseViewController {

    // MARK: - View

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
            homeArrivalView
        ].forEach { view.addSubview($0) }

        homeArrivalView.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalToSuperview().multipliedBy(0.3)
        }
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
