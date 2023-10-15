//
//  RecentStationCell.swift
//  CommuteFriend
//
//  Created by 박태현 on 2023/10/15.
//

import UIKit

final class RecentStationCell: BaseTableViewCell {

    private lazy var lineIconButton: UIButton = {
        let button = UIButton()
        return button
    }()

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15.0, weight: .bold)
        return label
    }()

    private lazy var directionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13.0, weight: .bold)
        return label
    }()

    override func configureUI() {
        super.configureUI()
        selectionStyle = .none
        backgroundColor = .systemGray6
    }

    override func configureLayout() {
        super.configureLayout()
        [
            lineIconButton, nameLabel, directionLabel
        ].forEach { addSubview($0) }
        lineIconButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(10)
            $0.top.bottom.equalToSuperview().inset(10)
        }
        nameLabel.snp.makeConstraints {
            $0.leading.equalTo(lineIconButton.snp.trailing).offset(10)
            $0.centerY.equalTo(lineIconButton)
        }
        directionLabel.snp.makeConstraints {
            $0.leading.equalTo(nameLabel.snp.trailing).offset(5)
            $0.bottom.equalTo(nameLabel)
            $0.trailing.lessThanOrEqualTo(contentView).inset(10)
        }
    }

    func configure(with stationTarget: SubwayTarget) {
        lineIconButton.configuration = .filledCapsuleConfiguration(
            foregroundColor: .white,
            backgroundColor: .subwayLineColor(stationTarget.lineNumber)
        )
        lineIconButton.configuration?.title = stationTarget.lineNumber.lineNum
        nameLabel.text = stationTarget.name
        directionLabel.text = stationTarget.destinationName + " 방면"
    }
}
