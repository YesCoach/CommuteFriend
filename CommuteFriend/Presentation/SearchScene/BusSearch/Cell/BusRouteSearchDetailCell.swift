//
//  BusRouteSearchDetailCell.swift
//  CommuteFriend
//
//  Created by 박태현 on 2023/10/18.
//

import UIKit

final class BusRouteSearchDetailCell: BaseCollectionViewCell {

    private lazy var nameLabel = UILabel()
    private lazy var routeLabel = UILabel()
    private lazy var backView = UIView()

    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
        routeLabel.text = nil
    }

    override func configureUI() {
        super.configureUI()
        contentView.backgroundColor = .systemBackground
        contentView.setViewShadow(backView: backView)
        contentView.layer.cornerRadius = 10.0
    }

    override func configureLayout() {
        super.configureLayout()
        [
            nameLabel, routeLabel, backView
        ].forEach { contentView.addSubview($0) }

        nameLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(10)
            $0.trailing.lessThanOrEqualToSuperview().inset(10)
        }
        routeLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(10)
            $0.leading.equalTo(nameLabel)
            $0.bottom.equalToSuperview().inset(10)
        }
        backView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    func configure(with busStation: BusStation) {
        nameLabel.text = busStation.name
        routeLabel.text = busStation.arsID
    }

}
