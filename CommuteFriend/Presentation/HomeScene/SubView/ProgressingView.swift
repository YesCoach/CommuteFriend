//
//  ProgressingView.swift
//  CommuteFriend
//
//  Created by 박태현 on 2023/10/11.
//

import UIKit

final class ProgressingView: UIView {

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
        if let arrivalResponse,
           let lineColor = UIColor(named: arrivalResponse.stationArrivalTarget.lineColorName)
        {
            drawLine(rect, with: lineColor)
        } else {
            drawLine(rect, with: .systemMint)
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }

    func configure(with response: StationArrivalResponse) {
        self.arrivalResponse = response
        setNeedsDisplay()
    }

    func drawLine(_ rect: CGRect, with lineColor: UIColor) {
        let path = UIBezierPath()
        path.move(to: .init(x: rect.minX, y: rect.midY))
        path.addLine(to: .init(x: rect.maxX, y: rect.midY))

        lineColor.setStroke()

        path.lineWidth = 3
        path.stroke()
    }
}

// MARK: - Private Method

private extension ProgressingView {

    func configureUI() {
        backgroundColor = .white
    }

    func configureLayout() { }
}
