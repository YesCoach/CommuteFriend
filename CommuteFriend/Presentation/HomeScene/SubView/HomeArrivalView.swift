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

    private var viewModel: HomeArrivalViewModel
    private var stationArrivalResponse: StationArrivalResponse?
    private var timer: Timer?
    private var updateFlag: Bool = true

    // MARK: - Init

    init(viewModel: HomeArrivalViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        configureUI()
        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        print("🗑️: \(String(describing: type(of: self))) deinit!")
    }

    func configure(with arrivalResponse: StationArrivalResponse) {
        self.stationArrivalResponse = arrivalResponse

        switch arrivalResponse.stationArrivalTarget {
        case .subway(let target):
            routeIconButton.configuration = .filledCapsuleConfiguration(
                foregroundColor: .white,
                backgroundColor: .subwayLineColor(target.lineNumber)
            )
            routeIconButton.configuration?.title = target.lineNumber.lineNum
            stationLabel.text = target.name
            destinationLabel.text = "다음역: \(target.destinationName)"
        case .bus(let target):
            // TODO: - Bus 상징색 적용하기
            routeIconButton.configuration = .filledCapsuleConfiguration(
                foregroundColor: .white,
                backgroundColor: .systemMint
            )
            routeIconButton.configuration?.title = target.busRouteName
            stationLabel.text = target.stationName
            destinationLabel.text = "\(target.direction) 방면"
        }

        arrivalInformationView.configure(wtih: arrivalResponse)
        progressingView.configure(with: arrivalResponse)
        removeTimer()
        attachTimer()
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
        routeIconButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)

        stationLabel.snp.makeConstraints {
            $0.centerY.equalTo(routeIconButton)
            $0.leading.equalTo(routeIconButton.snp.trailing).offset(5.0)
        }
        stationLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        destinationLabel.snp.makeConstraints {
            $0.leading.equalTo(stationLabel.snp.trailing).offset(5.0)
            $0.trailing.equalToSuperview().inset(20.0)
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

// MARK: - Timer

private extension HomeArrivalView {

    func attachTimer() {
        if let stationArrivalResponse {
            switch stationArrivalResponse.stationArrivalTarget {
            case .subway(let target):
                let lineList = [
                    SubwayLine.airport, .central, .uiSinseol, .gyeongGang, .gyeongchun,
                    .gyeonguiCentral, .seohae, .shinBundang, .suinBundang
                ]
                if lineList.contains(target.lineNumber) {
                    timer = Timer.scheduledTimer(
                        withTimeInterval: 10.0,
                        repeats: true
                    ) { [weak self] _ in
                        guard let self else { return }
                        updateStationArrivalDataByTerm()
                    }
                } else {
                    timer = Timer.scheduledTimer(
                        withTimeInterval: 1.0,
                        repeats: true
                    ) { [weak self] _ in
                        guard let self else { return }
                        updateStationArrivalDataBySecond()
                    }
                }
            case .bus:
                timer = Timer.scheduledTimer(
                    withTimeInterval: 1.0,
                    repeats: true
                ) { [weak self] _ in
                    guard let self else { return }
                    updateStationArrivalDataBySecond()
                }
            }
        }

        timer?.fire()
        print(#function)
    }

    func removeTimer() {
        print(#function)
        timer?.invalidate()
        timer = nil
    }

    // 타이머 업데이트 전략
    func updateStationArrivalDataBySecond( ) {
        if let stationArrivalResponse {
            switch stationArrivalResponse.stationArrival {
            case .subway(let arrival):
                // 지하철 다음 차량의 도착까지 남은시간이 0이면 새로 호출
                if arrival[safe: 0]?.remainSecond ?? 0 <= 0 {
                    if updateFlag {
                        DispatchQueue.global().asyncAfter(deadline: .now() + 10.0) { [weak self] in
                            guard let self else { return }
                            viewModel.refreshCurrentStationTarget()
                            updateFlag = true
                        }
                    }
                    updateFlag = false
                }
                progressingView.configure(with: stationArrivalResponse)
                arrivalInformationView.configure(wtih: stationArrivalResponse)
            case .bus:
                progressingView.configure(with: stationArrivalResponse)
                arrivalInformationView.configure(wtih: stationArrivalResponse)
            }
        }
    }

    func updateStationArrivalDataByTerm() {
        viewModel.refreshCurrentStationTarget()
    }
}
