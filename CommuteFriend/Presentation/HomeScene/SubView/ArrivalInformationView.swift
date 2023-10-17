//
//  ArrivalInformationView.swift
//  CommuteFriend
//
//  Created by 박태현 on 2023/10/11.
//

import UIKit

final class ArrivalInformationView: UIView {

    private lazy var currentDestinationLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20.0, weight: .bold)
        return label
    }()

    private lazy var currentTimeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22.0, weight: .bold)
        label.textColor = .systemRed
        return label
    }()

    private lazy var nextLabel: UILabel = {
        let label = UILabel()
        label.text = "다음열차"
        return label
    }()

    private lazy var nextDestinationLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    private lazy var nextTimeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .systemRed
        return label
    }()

    private lazy var currentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 4.0
        stackView.alignment = .center
        stackView.distribution = .fill
        return stackView
    }()

    private lazy var nextStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 4.0
        stackView.alignment = .center
        return stackView
    }()

    private var arrivalResponse: StationArrivalResponse?

    init() {
        super.init(frame: .zero)
        configureUI()
        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(wtih arrivalResponse: StationArrivalResponse) {
        self.arrivalResponse = arrivalResponse
        configure(with: arrivalResponse.stationArrival)
    }

}

// MARK: - Private Method

private extension ArrivalInformationView {

    func configureUI() {
        backgroundColor = .systemBackground
    }

    func configureLayout() {
        [
            currentStackView, nextStackView
        ].forEach { addSubview($0) }

        [
            currentDestinationLabel, currentTimeLabel
        ].forEach { currentStackView.addArrangedSubview($0) }

        [
            nextLabel, nextDestinationLabel, nextTimeLabel
        ].forEach { nextStackView.addArrangedSubview($0) }

        currentStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10)
            $0.centerX.equalToSuperview()
            $0.horizontalEdges.greaterThanOrEqualTo(10).priority(.low)
            $0.bottom.equalTo(self.snp.centerY)
        }
        nextStackView.snp.makeConstraints {
            $0.top.equalTo(currentStackView.snp.bottom)
            $0.bottom.centerX.equalToSuperview()
            $0.horizontalEdges.greaterThanOrEqualTo(10).priority(.low)
        }
    }

    func configure(with arrival: StationArrivalResponse.Arrival) {
        switch arrival {
        case .subway(let arrival):
            currentDestinationLabel.text = arrival[safe: 0]?.destination ?? "도착정보 없음"

            // 만약 남은시간이 0일 경우 -> 실시간 도착 시간 미제공 구간!

            if arrival[safe: 0]?.remainTimeForSecond == "0" {
                if let arrivalMessage = arrival[safe: 0]?.arrivalMessage {
                    currentTimeLabel.text = arrivalMessage
                }
            } else {
                currentTimeLabel.text = arrival[safe: 0]?.conveniencedRemainTimeSecond ?? ""
            }

            nextDestinationLabel.text = arrival[safe: 1]?.destination ?? "도착정보 없음"

            // 만약 남은시간이 0일 경우 -> 실시간 도착 시간 미제공 구간!
            if arrival[safe: 1]?.remainTimeForSecond == "0" {
                if let arrivalMessage = arrival[safe: 1]?.arrivalMessage {
                    nextTimeLabel.text = arrivalMessage
                }
            } else {
                nextTimeLabel.text = arrival[safe: 1]?.conveniencedRemainTimeSecond ?? ""
            }
        case .bus(let arrival):
            return
        }
    }

}
