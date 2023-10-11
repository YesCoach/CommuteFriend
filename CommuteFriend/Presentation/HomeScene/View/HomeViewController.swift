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

    // MARK: - Method

    override func configureUI() {
        super.configureUI()
        view.backgroundColor = .systemRed
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
