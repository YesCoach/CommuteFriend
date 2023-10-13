//
//  SearchHistoryCell.swift
//  CommuteFriend
//
//  Created by 박태현 on 2023/10/11.
//

import UIKit

final class SearchHistoryCell: BaseTableViewCell {

    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView(image: .init(systemName: "clock"))
        return imageView
    }()

    private lazy var historyLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14.0, weight: .regular)
        return label
    }()

    override func prepareForReuse() {
        super.prepareForReuse()
        historyLabel.text = ""
    }

    override func configureUI() {
        super.configureUI()
        selectionStyle = .none
    }

    override func configureLayout() {
        super.configureLayout()

        [
            iconImageView, historyLabel
        ].forEach { contentView.addSubview($0) }

        iconImageView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(10.0)
            $0.leading.equalToSuperview().inset(20.0)
        }

        historyLabel.snp.makeConstraints {
            $0.verticalEdges.equalTo(iconImageView)
            $0.leading.equalTo(iconImageView.snp.trailing).offset(10.0)
            $0.trailing.lessThanOrEqualToSuperview().inset(20.0)
        }
    }

}

extension SearchHistoryCell {

    func configure(with history: String) {
        historyLabel.text = history
    }

}
