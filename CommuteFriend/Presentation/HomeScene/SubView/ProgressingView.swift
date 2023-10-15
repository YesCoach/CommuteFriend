//
//  ProgressingView.swift
//  CommuteFriend
//
//  Created by 박태현 on 2023/10/11.
//

import UIKit

final class ProgressingView: UIView {

    // MARK: - View

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()

    private var arrivalResponse: StationArrivalResponse?

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        configureLayout()
        backgroundColor = .secondarySystemBackground
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)

        let path = UIBezierPath()
        path.move(to: .init(x: rect.minX, y: rect.midY * 1.5))
        path.addLine(to: .init(x: rect.maxX, y: rect.midY * 1.5))

        UIColor.systemMint.setStroke()

        path.lineWidth = 3
        path.stroke()
    }

    func configure(with: StationArrivalResponse) {
        print(with)
    }
}

// MARK: - Private Method

private extension ProgressingView {

    func configureUI() { }

    func configureLayout() {
        [
            imageView
        ].forEach { addSubview($0) }
    }

}
