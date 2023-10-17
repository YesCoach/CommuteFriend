//
//  SearchHistoryHeaderView.swift
//  CommuteFriend
//
//  Created by 박태현 on 2023/10/12.
//

import UIKit

final class SearchHistoryHeaderView: UITableViewHeaderFooterView {

    static var reuseIdentifier: String {
        return String(describing: self)
    }

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "최근 검색"
        return label
    }()

    private lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.setTitle("전체 삭제", for: .normal)
        button.setTitleColor(.systemGray, for: .normal)
        button.addTarget(self, action: #selector(didDeleteButtonTouched), for: .touchUpInside)
        return button
    }()

    var deleteButtonHandler: (() -> Void)?

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

private extension SearchHistoryHeaderView {

    func configureLayout() {
        [
            titleLabel, deleteButton
        ].forEach {
            self.addSubview($0)
        }

        titleLabel.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview().inset(10)
        }
        deleteButton.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel)
            $0.trailing.equalToSuperview().inset(10)
        }
    }

    @objc func didDeleteButtonTouched() {
        deleteButtonHandler?()
    }
}
