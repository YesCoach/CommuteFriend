//
//  MenuSelectableView.swift
//  CommuteFriend
//
//  Created by 박태현 on 2023/10/15.
//

import UIKit

final class MenuSelectableView: UIView {

    enum MenuType {
        case subway
        case bus
        case favorite

        var description: String {
            switch self {
            case .subway: return "지하철 검색"
            case .bus: return "버스 검색"
            case .favorite: return "즐겨찾기"
            }
        }

        var imageName: String {
            switch self {
            case .subway: return "tram.fill"
            case .bus: return "bus.fill"
            case .favorite: return "bookmark.fill"
            }
        }
    }

    // MARK: - View

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .init(systemName: menuType.imageName)
        imageView.tintColor = .label
        imageView.isUserInteractionEnabled = true
        return imageView
    }()

    private lazy var label: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title3)
        label.adjustsFontForContentSizeCategory = true
        label.text = menuType.description
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

    private let menuType: MenuType
    private let completion: ((MenuType) -> Void)

    // MARK: - Init

    init(
        menuType: MenuType,
        completion: @escaping ((MenuType) -> Void)
    ) {
        self.menuType = menuType
        self.completion = completion
        super.init(frame: .zero)
        configureUI()
        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func viewDidSelected(_ sender: UITapGestureRecognizer) {
        completion(menuType)
    }

}

// MARK: - Private Method

private extension MenuSelectableView {

    func configureUI() {
        layer.cornerRadius = 15.0
        backgroundColor = .systemGray6
        self.addGestureRecognizer(tapGesture)
    }

    func configureLayout() {
        [
            imageView, label
        ].forEach { addSubview($0) }

        imageView.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(15.0)
            $0.width.height.equalTo(30.0)
        }

        label.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(15.0)
            $0.leading.equalTo(imageView)
            $0.bottom.equalToSuperview().inset(10)
        }
    }

}
