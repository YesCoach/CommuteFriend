//
//  HomeArrivalView.swift
//  CommuteFriend
//
//  Created by 박태현 on 2023/10/11.
//

import UIKit

final class HomeArrivalView: UIView {

    // MARK: - View

    private lazy var routeIconButton: UIButton = {
        let button = UIButton()
        return button
    }()

    private lazy var stationLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16.0, weight: .bold)
        return label
    }()

    private lazy var destinationLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14.0, weight: .bold)
        return label
    }()

    private lazy var progressingView: ProgressingView = ProgressingView()
    private lazy var arrivalInformationView: ArrivalInformationView = ArrivalInformationView()

    // MARK: - Init

    init() {
        super.init(frame: .zero)
        configureUI()
        configureLayout()
        configureData()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureData() {
        routeIconButton.configuration = .filledCapsuleConfiguration(
            foregroundColor: .white, backgroundColor: .systemGreen
        )
        routeIconButton.configuration?.title = "2"
        stationLabel.text = "시청"
        destinationLabel.text = "다음역: 문래"
    }

}

// MARK: - Private Methods

private extension HomeArrivalView {

    func configureUI() {
        backgroundColor = .systemBackground
    }

    func configureLayout() {
        [
            routeIconButton, stationLabel, destinationLabel,
            progressingView, arrivalInformationView
        ].forEach {
            addSubview($0)
        }

        routeIconButton.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(10.0)
        }

        stationLabel.snp.makeConstraints {
            $0.centerY.equalTo(routeIconButton)
            $0.leading.equalTo(routeIconButton.snp.trailing).offset(5.0)
        }

        destinationLabel.snp.makeConstraints {
            $0.leading.equalTo(stationLabel.snp.trailing).offset(5.0)
            $0.bottom.equalTo(stationLabel)
        }

        progressingView.snp.makeConstraints {
            $0.top.equalTo(routeIconButton.snp.bottom).offset(10)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(100)
        }

        arrivalInformationView.snp.makeConstraints {
            $0.top.equalTo(progressingView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}
