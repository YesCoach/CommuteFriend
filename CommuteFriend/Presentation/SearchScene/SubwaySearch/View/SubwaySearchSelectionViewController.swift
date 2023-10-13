//
//  SubwaySearchSelectionViewController.swift
//  CommuteFriend
//
//  Created by 박태현 on 2023/10/13.
//

import UIKit

final class SubwaySearchDirectionSelectViewController: BaseViewController {

    // MARK: - UI Components

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "방향을 선택하세요"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()

    private lazy var upDirectionView: SelectableView = {
        let view = SelectableView(
            selectableType: UpDownDirection.up
        ) { [weak self] selectableType in
            guard let self,
                  let direction = selectableType as? UpDownDirection
            else { return }
            viewModel.didSelectDirection(direction: direction)
        }
        return view
    }()

    private lazy var downDirectionView: SelectableView = {
        let view = SelectableView(
            selectableType: UpDownDirection.down
        ) { [weak self] selectableType in
            guard let self,
                  let direction = selectableType as? UpDownDirection
            else { return }
            viewModel.didSelectDirection(direction: direction)
        }
        return view
    }()

    private lazy var splitDirectionView: SelectableView = {
        let view = SelectableView(
            selectableType: UpDownDirection.split
        ) { [weak self] selectableType in
            guard let self,
                  let direction = selectableType as? UpDownDirection
            else { return }
            viewModel.didSelectDirection(direction: direction)
        }
        return view
    }()

    private lazy var verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 20
        [
            horizontalStackView, splitDirectionView
        ].forEach { stackView.addArrangedSubview($0) }
        return stackView
    }()

    private lazy var horizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        stackView.spacing = 20
        [
            upDirectionView, downDirectionView
        ].forEach { stackView.addArrangedSubview($0) }
        return stackView
    }()

    private let viewModel: SubwaySearchDirectionSelectViewModel

    // MARK: - Initializer

    init(viewModel: SubwaySearchDirectionSelectViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        print("🗑️ - \(String(describing: type(of: self)))")
    }

    // MARK: - Methods

    override func configureUI() {
        super.configureUI()
        view.backgroundColor = .systemBackground
    }

    override func configureLayout() {
        super.configureLayout()
        [
            descriptionLabel, verticalStackView
        ].forEach { view.addSubview($0) }

        descriptionLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(40)
            $0.leading.equalToSuperview().inset(16)
        }
        verticalStackView.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(40)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
//        upDirectionView.snp.makeConstraints {
//            $0.height.equalTo(120)
//        }
//        downDirectionView.snp.makeConstraints {
//            $0.height.equalTo(120)
//        }
        splitDirectionView.snp.makeConstraints {
            $0.width.equalTo(verticalStackView)
        }

//        splitDirectionView.isHidden = true
    }

}
