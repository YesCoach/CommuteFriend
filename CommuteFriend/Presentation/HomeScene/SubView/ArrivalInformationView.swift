//
//  ArrivalInformationView.swift
//  CommuteFriend
//
//  Created by 박태현 on 2023/10/11.
//

import UIKit

final class ArrivalInformationView: UIView {

    init() {
        super.init(frame: .zero)
        configureUI()
        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - Private Method

private extension ArrivalInformationView {

    func configureUI() {
        backgroundColor = .systemMint
    }

    func configureLayout() {

    }

}
