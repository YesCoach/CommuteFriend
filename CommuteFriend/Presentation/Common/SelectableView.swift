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
        label.textAlignment = .center
        label.font = .preferredFont(forTextStyle: .headline)
        label.adjustsFontForContentSizeCategory = true
        label.adjustsFontSizeToFitWidth = true
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
    private var selectableText: String?
    private let completion: ((SelectableType, String?) -> Void)

    // MARK: - Init

    init(
        selectableType: SelectableType,
        description: String?,
        completion: @escaping ((SelectableType, String?) -> Void)
    ) {
        self.selectableType = selectableType
        self.completion = completion
        super.init(frame: .zero)
        label.text = description
        configureUI()
        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func viewDidSelected(_ sender: UITapGestureRecognizer) {
        completion(selectableType, selectableText)
    }

    func configure(with description: String) {
        self.selectableText = description
        self.label.text = description
    }

}

// MARK: - Private Method

private extension SelectableView {

    func configureUI() {
        layer.cornerRadius = 15.0
        layer.cornerCurve = .continuous
        backgroundColor = .selectionColor
        self.addGestureRecognizer(tapGesture)
    }

    func configureLayout() {
        [
            imageView, label
        ].forEach { addSubview($0) }

        imageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(40.0)
        }

        label.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.greaterThanOrEqualTo(imageView.snp.bottom).offset(10)
            $0.bottom.equalToSuperview().inset(10)
            $0.horizontalEdges.equalToSuperview().inset(10)
        }
    }

}
