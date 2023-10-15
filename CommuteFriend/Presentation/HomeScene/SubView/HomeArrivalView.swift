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

    private var subwayStationArrival: StationArrivalResponse?

    // MARK: - Init

    init() {
        super.init(frame: .zero)
        configureUI()
        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with arrivalResponse: StationArrivalResponse) {
        self.subwayStationArrival = arrivalResponse

        let stationTarget = arrivalResponse.stationArrivalTarget

        routeIconButton.configuration = .filledCapsuleConfiguration(
            foregroundColor: .white,
            backgroundColor: .subwayLineColor(stationTarget.lineNumber)
        )
        routeIconButton.configuration?.title = stationTarget.lineNumber.lineNum
        stationLabel.text = stationTarget.name
        destinationLabel.text = "다음역: \(stationTarget.destinationName)"

        arrivalInformationView.configure(wtih: arrivalResponse)
        progressingView.configure(with: arrivalResponse)
    }

}

// MARK: - Private Methods

private extension HomeArrivalView {

    func configureUI() {
        backgroundColor = .systemBackground

        self.layer.cornerRadius = 30.0
        self.layer.cornerCurve = .continuous
        self.layer.masksToBounds = true
    }

    func configureLayout() {
        [
            routeIconButton, stationLabel, destinationLabel,
            progressingView, arrivalInformationView
        ].forEach {
            addSubview($0)
        }

        routeIconButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10.0)
            $0.leading.equalToSuperview().offset(20.0)
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
            $0.height.equalTo(70)
        }

        arrivalInformationView.snp.makeConstraints {
            $0.top.equalTo(progressingView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}
