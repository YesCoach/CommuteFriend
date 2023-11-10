//
//  SettingViewCell.swift
//  CommuteFriend
//
//  Created by 박태현 on 2023/11/10.
//

import UIKit

final class SettingViewCell: BaseTableViewCell {

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15.0, weight: .semibold)
        return label
    }()

    private lazy var accessoryImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()

    private lazy var accessoryLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15.0, weight: .semibold)
        return label
    }()

    override func configureLayout() {
        super.configureLayout()

        [
            titleLabel, accessoryLabel
        ].forEach { contentView.addSubview($0) }

        titleLabel.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(10.0)
            $0.leading.equalToSuperview().inset(10.0)
        }

        accessoryLabel.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(10.0)
            $0.trailing.equalToSuperview().inset(10.0)
        }
    }
}
