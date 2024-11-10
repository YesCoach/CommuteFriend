//
//  FavoriteStationCell.swift
//  CommuteFriend
//
//  Created by 박태현 on 2023/10/16.
//

import UIKit

final class FavoriteStationCell: BaseTableViewCell {

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
        label.adjustsFontSizeToFitWidth = true
        return label
    }()

    private lazy var alarmButton: UIButton = {
        let button = UIButton()
        button.setImage(.init(systemName: "bell.fill"), for: .normal)
        button.setImage(.init(systemName: "bell.slash.fill"), for: .selected)
        button.addTarget(
            self,
            action: #selector(didAlarmButtonTouched(_:)),
            for: .touchUpInside
        )
        button.tintColor = .label
        return button
    }()

    var didAlarmButtonSelected: ((Bool) -> Void)?

    override func prepareForReuse() {
        super.prepareForReuse()
        didAlarmButtonSelected = nil
    }

    override func configureUI() {
        super.configureUI()
        selectionStyle = .none
    }

    override func configureLayout() {
        super.configureLayout()
        [
            lineIconButton, nameLabel, directionLabel, alarmButton
        ].forEach { contentView.addSubview($0) }
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
            $0.trailing.lessThanOrEqualTo(alarmButton.snp.leading).offset(-5)
        }
        alarmButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(10)
            $0.verticalEdges.equalToSuperview()
        }

        lineIconButton.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        nameLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    }

    func configure(with favoriteItem: FavoriteItem) {
        alarmButton.isSelected = !favoriteItem.isAlarm

        switch favoriteItem.stationTarget {
        case .subway(let target):
            lineIconButton.configuration = .filledCapsuleConfiguration(
                foregroundColor: .white,
                backgroundColor: .subwayLineColor(target.lineNumber)
            )
            lineIconButton.configuration?.title = target.lineNumber.lineNum
            nameLabel.text = target.name
            directionLabel.text = target.destinationName + " 방면"
        case .bus(let target):
            lineIconButton.configuration = .filledCapsuleConfiguration(
                foregroundColor: .white,
                backgroundColor: .busTypeColor(target.busType)
            )
            lineIconButton.configuration?.title = target.busRouteName
            nameLabel.text = target.stationName
            directionLabel.text = target.direction + " 방면"
        }
    }

    @objc func didAlarmButtonTouched(_ sender: UIButton) {
        sender.isSelected.toggle()
        didAlarmButtonSelected?(sender.isSelected)
    }

}
