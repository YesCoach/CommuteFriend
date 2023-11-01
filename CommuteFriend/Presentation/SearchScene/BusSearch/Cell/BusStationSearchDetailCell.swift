//
//  BusStationSearchDetailCell.swift
//  CommuteFriend
//
//  Created by 박태현 on 2023/10/18.
//

import UIKit

final class BusStationSearchDetailCell: BaseCollectionViewCell {

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14.0, weight: .semibold)
        return label
    }()

    private lazy var routeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14.0, weight: .semibold)
        return label
    }()
    
    private lazy var backView: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14.0, weight: .semibold)
        return label
    }()

    private var busStationArrival: BusArrival? {
        didSet {
            guard let busStationArrival else { return }
            nameLabel.text = busStationArrival.busRouteName
            routeLabel.text = "\(busStationArrival.nextStationName) 방면"
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        ].forEach { addSubview($0) }

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

    func configure(with busStationArrival: BusArrival) {
        self.busStationArrival = busStationArrival
    }

}
