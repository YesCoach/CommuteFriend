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
        label.font = .preferredFont(forTextStyle: .headline)
        label.adjustsFontForContentSizeCategory = true
        return label
    }()

    private lazy var directionLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.adjustsFontForContentSizeCategory = true
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

    func configure<T: StationTarget>(with stationTarget: T) {
        if let target = stationTarget as? SubwayTarget {
            lineIconButton.configuration = .filledCapsuleConfiguration(
                foregroundColor: .white,
                backgroundColor: .subwayLineColor(target.lineNumber)
            )
            lineIconButton.configuration?.title = target.lineNumber.lineNum
            nameLabel.text = target.name
            directionLabel.text = target.destinationName + " 방면"
        }
        if let target = stationTarget as? BusTarget {
            // TODO: Bus 상징색 적용
            lineIconButton.configuration = .filledCapsuleConfiguration(
                foregroundColor: .white,
                backgroundColor: .busTypeColor(target.busType)
            )
            lineIconButton.configuration?.title = target.busRouteName
            nameLabel.text = target.stationName
            directionLabel.text = target.direction + " 방면"
        }
    }
}
