//
//  SelectableView.swift
//  CommuteFriend
//
//  Created by 박태현 on 2023/10/11.
//

import UIKit

final class SelectableView: UIView {

    // MARK: - View

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .init(systemName: selectableType.imageName)
        imageView.tintColor = .label
        imageView.isUserInteractionEnabled = true
        return imageView
    }()

    private lazy var label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.text = selectableType.description
        return label
    }()

    private lazy var tapGesture: UITapGestureRecognizer = {
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(viewDidSelected)
        )
        return tapGesture
    }()

    // MARK: - Property

    private let selectableType: SelectableType
    private let completion: ((SelectableType) -> Void)

    // MARK: - Init

    init(selectableType: SelectableType, completion: @escaping ((SelectableType) -> Void)) {
        self.selectableType = selectableType
        self.completion = completion
        super.init(frame: .zero)

        configureUI()
        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func viewDidSelected(_ sender: UITapGestureRecognizer) {
        completion(selectableType)
    }

}

// MARK: - Private Method

private extension SelectableView {

    func configureUI() {
        layer.cornerRadius = 15.0
        backgroundColor = .systemRed.withAlphaComponent(0.3)
        self.addGestureRecognizer(tapGesture)
    }

    func configureLayout() {
        [
            imageView, label
        ].forEach { addSubview($0) }

        imageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(40.0)
        }

        label.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(10)
        }
    }

}
