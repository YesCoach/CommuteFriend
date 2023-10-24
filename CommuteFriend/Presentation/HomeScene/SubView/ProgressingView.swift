//
//  ProgressingView.swift
//  CommuteFriend
//
//  Created by 박태현 on 2023/10/11.
//

import UIKit

final class ProgressingView: UIView {

    // MARK: - View

    private lazy var commuteImageView: UIImageView = {
        let imageView = UIImageView()
        switch transportType {
        case .subway:
            imageView.image = .init(systemName: "train.side.front.car")
        case .bus:
            imageView.image = .init(named: "bus.png")
        }
        imageView.tintColor = .purple
        return imageView
    }()


    private var arrivalResponse: StationArrivalResponse?
    private let transportType: TransportationType

    // MARK: - Init

    init(transportType: TransportationType) {
        self.transportType = transportType
        super.init(frame: .zero)
        configureUI()
        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)

        let path = UIBezierPath()
        path.move(to: .init(x: rect.minX, y: rect.midY * 1.3))
        path.addLine(to: .init(x: rect.maxX, y: rect.midY * 1.3))

        UIColor.systemMint.setStroke()

        path.lineWidth = 3
        path.stroke()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }

    func animationOn() {
        layoutIfNeeded()
        commuteImageView.frame = .init(x: -50, y: frame.midY * 1.3, width: 50, height: 25)

        layoutIfNeeded()
        UIView.animate(
            withDuration: 2.0,
            delay: 3,
            options: [.repeat, .curveLinear]
        ) { [weak self] in
            guard let self else { return }
            print(Thread.isMainThread)
            commuteImageView.frame.origin.x = frame.size.width
            layoutIfNeeded()
            print("animation On")
        } completion: { bool in
            print("completion Block")
            print(Thread.isMainThread)
        }
    }

    func configure(with: StationArrivalResponse) { }
}

// MARK: - Private Method

private extension ProgressingView {

    func configureUI() {
        backgroundColor = .white
    }

    func configureLayout() {
        [
            commuteImageView
        ].forEach { addSubview($0) }
    }
}
