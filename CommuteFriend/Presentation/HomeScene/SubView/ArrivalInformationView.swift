//
//  ArrivalInformationView.swift
//  CommuteFriend
//
//  Created by 박태현 on 2023/10/11.
//

import UIKit
import Lottie

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

    private lazy var refreshButtonView: LottieAnimationView = {
        let view = LottieAnimationView.init(name: "refreshLottie")
        view.contentMode = .scaleAspectFit
        view.loopMode = .playOnce
        view.animationSpeed = 1.0
        view.addGestureRecognizer(refreshTapGesture)
        view.layer.cornerRadius = 15.0
        view.layer.cornerCurve = .circular
        view.backgroundColor = .systemMint
        return view
    }()

    private lazy var refreshTapGesture: UITapGestureRecognizer = {
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(didRefreshButtonTouched)
        )
        return tapGesture
    }()

    @objc func didRefreshButtonTouched(_ sender: UITapGestureRecognizer) {
        // todo: - refresh
        refreshButtonView.play()
        refreshButtonTouched()
    }

    private var arrivalResponse: StationArrivalResponse?
    private var refreshButtonTouched: (() -> Void)

    init(completion: @escaping (() -> Void)) {
        refreshButtonTouched = completion
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
            currentStackView, nextStackView, refreshButtonView
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

        refreshButtonView.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(10)
            $0.trailing.equalToSuperview().inset(20)
            $0.size.equalTo(30)
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
                currentTimeLabel.text = arrival[safe: 0]?.arrivalTimeDescription ?? ""
            }

            nextDestinationLabel.text = arrival[safe: 1]?.destination ?? "도착정보 없음"

            // 만약 남은시간이 0일 경우 -> 실시간 도착 시간 미제공 구간!
            if arrival[safe: 1]?.remainTimeForSecond == "0" {
                if let arrivalMessage = arrival[safe: 1]?.arrivalMessage {
                    nextTimeLabel.text = arrivalMessage
                }
            } else {
                nextTimeLabel.text = arrival[safe: 1]?.arrivalTimeDescription ?? ""
            }
        case .bus(let arrival):
            currentDestinationLabel.isHidden = true
            nextLabel.text = "다음편"
            currentTimeLabel.text = arrival[safe: 0]?.firstArrivalTimeDescription ?? "도착정보 없음"
            nextTimeLabel.text = arrival[safe: 0]?.secondArrivalTimeDescription ?? "도착정보 없음"
        }
    }

}
