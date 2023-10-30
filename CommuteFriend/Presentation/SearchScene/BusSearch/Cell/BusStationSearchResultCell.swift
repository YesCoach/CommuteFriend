//
//  BusStationSearchResultCell.swift
//  CommuteFriend
//
//  Created by 박태현 on 2023/10/12.
//

import UIKit

final class BusStationSearchResultCell: BaseTableViewCell {

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14.0, weight: .semibold)
        return label
    }()

    private lazy var stationIDLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14.0, weight: .semibold)
        return label
    }()

    private lazy var stationPlaceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14.0, weight: .semibold)
        return label
    }()

    private lazy var separatorLabel: UILabel = {
        let label = UILabel()
        label.text = "|"
        label.font = .systemFont(ofSize: 14.0, weight: .semibold)
        label.textColor = .systemGray
        return label
    }()

    override func configureUI() {
        super.configureUI()
        contentView.backgroundColor = .systemBackground
        selectionStyle = .none
    }

    override func configureLayout() {
        super.configureLayout()
        [
            nameLabel, stationIDLabel, stationPlaceLabel, separatorLabel
        ].forEach { addSubview($0) }
        nameLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(10)
            $0.trailing.lessThanOrEqualToSuperview().inset(10)
        }
        stationIDLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(5)
            $0.leading.equalTo(nameLabel)
            $0.bottom.equalToSuperview().inset(10)
        }
        separatorLabel.snp.makeConstraints {
            $0.leading.equalTo(stationIDLabel.snp.trailing).offset(5)
            $0.trailing.equalTo(stationPlaceLabel.snp.leading).offset(-5)
            $0.top.bottom.equalTo(stationIDLabel)
        }
        stationPlaceLabel.snp.makeConstraints {
            $0.top.bottom.equalTo(stationIDLabel)
            $0.trailing.lessThanOrEqualToSuperview().inset(10)
        }
    }

    func configure(with station: BusStation) {
        nameLabel.text = station.name
        stationIDLabel.text = station.arsID
        stationPlaceLabel.text = station.direction
    }
}
