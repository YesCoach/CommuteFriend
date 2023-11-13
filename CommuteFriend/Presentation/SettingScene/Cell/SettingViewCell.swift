//
//  SettingViewCell.swift
//  CommuteFriend
//
//  Created by 박태현 on 2023/11/10.
//

import UIKit
import RxSwift
import RxCocoa

final class SettingViewCell: BaseTableViewCell {

    // MARK: - View

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14.0, weight: .semibold)
        return label
    }()

    private lazy var accessoryImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()

    private lazy var accessoryLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14.0, weight: .regular)
        label.textColor = .link
        return label
    }()

    // MARK: - Methods

    override func configureUI() {
        super.configureUI()
        selectionStyle = .none
    }

    override func configureLayout() {
        super.configureLayout()

        [
            titleLabel, accessoryLabel
        ].forEach { contentView.addSubview($0) }

        titleLabel.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(10.0)
            $0.leading.equalToSuperview().inset(20.0)
        }

        accessoryLabel.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(10.0)
            $0.trailing.equalToSuperview().inset(20.0)
        }
    }

    func configure(with item: SettingItem) {
        titleLabel.text = item.description
        accessoryLabel.text = item.accessory
    }
}
