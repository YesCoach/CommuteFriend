//
//  SubwaySearchResultCell.swift
//  CommuteFriend
//
//  Created by 박태현 on 2023/10/12.
//

import UIKit

final class SubwaySearchResultCell: BaseTableViewCell {

    private lazy var lineIconButton: UIButton = {
        let button = UIButton()
        return button
    }()

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
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
            lineIconButton, nameLabel
        ].forEach { addSubview($0) }
        lineIconButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(10)
            $0.top.bottom.equalToSuperview().inset(10)
        }
        nameLabel.snp.makeConstraints {
            $0.leading.equalTo(lineIconButton.snp.trailing).offset(10)
            $0.centerY.equalTo(lineIconButton)
        }
    }

    func configure(with station: SubwayStation) {
        lineIconButton.configuration = .filledCapsuleConfiguration(
            foregroundColor: .white,
            backgroundColor: .subwayLineColor(station.lineNumber)
        )
        lineIconButton.configuration?.title = station.lineNumber.lineNum
        nameLabel.text = station.name
    }
}
