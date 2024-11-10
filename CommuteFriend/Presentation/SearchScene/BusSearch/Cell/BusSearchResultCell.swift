//
//  BusSearchResultCell.swift
//  CommuteFriend
//
//  Created by 박태현 on 2023/10/18.
//

import UIKit

final class BusSearchResultCell: BaseTableViewCell {

    private lazy var typeLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline)
        label.adjustsFontForContentSizeCategory = true
        return label
    }()

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline)
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    private lazy var routeLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline)
        label.adjustsFontForContentSizeCategory = true
        return label
    }()

    override func prepareForReuse() {
        super.prepareForReuse()
        typeLabel.text = nil
        nameLabel.text = nil
        routeLabel.text = nil
    }
    override func configureUI() {
        super.configureUI()
        contentView.backgroundColor = .systemBackground
        selectionStyle = .none
    }

    override func configureLayout() {
        super.configureLayout()
        [
            typeLabel, nameLabel, routeLabel
        ].forEach { contentView.addSubview($0) }

        typeLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(10)
        }
        nameLabel.snp.makeConstraints {
            $0.top.bottom.equalTo(typeLabel)
            $0.leading.equalTo(typeLabel.snp.trailing).offset(10)
            $0.trailing.lessThanOrEqualToSuperview().inset(10)
        }
        routeLabel.snp.makeConstraints {
            $0.top.equalTo(typeLabel.snp.bottom).offset(5)
            $0.leading.equalTo(typeLabel)
            $0.bottom.equalToSuperview().inset(10)
        }
    }

    func configure(with bus: Bus) {
        typeLabel.text = bus.kind.description
        nameLabel.text = bus.name
        routeLabel.text = bus.direction
    }
}
