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
        label.text = "의정부행"
        label.font = .systemFont(ofSize: 20.0, weight: .bold)
        return label
    }()

    private lazy var currentTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "2분 10초"
        label.font = .systemFont(ofSize: 24.0, weight: .bold)
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
        label.text = "의정부행"
        return label
    }()

    private lazy var nextTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "20분"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .systemRed
        return label
    }()

    private lazy var currentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 4.0
        stackView.alignment = .center
        return stackView
    }()

    private lazy var nextStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 4.0
        stackView.alignment = .center
        return stackView
    }()

    init() {
        super.init(frame: .zero)
        configureUI()
        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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

}
