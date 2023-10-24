//
//  SubwaySearchSelectionViewController.swift
//  CommuteFriend
//
//  Created by 박태현 on 2023/10/13.
//

import UIKit
import RxSwift

final class SubwaySearchSelectionViewController: BaseViewController {

    // MARK: - UI Components

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "방향을 선택하세요"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()

    private lazy var upDirectionView: SelectableView = {
        let view = SelectableView(
            selectableType: UpDownDirection.up,
            description: ""
        ) { [weak self] selectableType, stationName in
            guard let self else { return }
            didSelectableViewTouched(selectableType: selectableType, stationName: stationName)
        }
        return view
    }()

    private lazy var downDirectionView: SelectableView = {
        let view = SelectableView(
            selectableType: UpDownDirection.down,
            description: ""
        ) { [weak self] selectableType, stationName in
            guard let self else { return }
            didSelectableViewTouched(selectableType: selectableType, stationName: stationName)
        }
        return view
    }()

    private lazy var splitDirectionView: SelectableView = {
        let view = SelectableView(
            selectableType: UpDownDirection.split,
            description: ""
        ) { [weak self] selectableType, stationName in
            guard let self else { return }
            didSelectableViewTouched(selectableType: selectableType, stationName: stationName)
        }
        return view
    }()

    private lazy var verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 10
        [
            horizontalStackView, splitDirectionView
        ].forEach { stackView.addArrangedSubview($0) }
        return stackView
    }()

    private lazy var horizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        stackView.spacing = 10
        [
            upDirectionView, downDirectionView
        ].forEach { stackView.addArrangedSubview($0) }
        return stackView
    }()

    private let viewModel: SubwaySearchSelectionViewModel
    private let disposeBag = DisposeBag()

    // MARK: - Initializer

    init(viewModel: SubwaySearchSelectionViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        deinitPrint()
    }

    // MARK: - Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDidLoad()
        bindViewModel()
    }

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
        splitDirectionView.snp.makeConstraints {
            $0.width.equalTo(verticalStackView)
        }
    }

}

private extension SubwaySearchSelectionViewController {

    func bindViewModel() {
        viewModel.upStation.bind(with: self) { owner, upStation in
            if let upStation {
                owner.upDirectionView.isHidden = false
                owner.upDirectionView.configure(with: upStation.name)
            } else {
                owner.upDirectionView.isHidden = true
            }
        }.disposed(by: disposeBag)

        viewModel.downStation.bind(with: self) { owner, downStation in
            if let downStation {
                owner.downDirectionView.isHidden = false
                owner.downDirectionView.configure(with: downStation.name)
            } else {
                owner.downDirectionView.isHidden = true
            }
        }.disposed(by: disposeBag)

        viewModel.splitStation.bind(with: self) { owner, splitStation in
            if let splitStation {
                owner.splitDirectionView.isHidden = false
                owner.splitDirectionView.configure(with: splitStation.name)
            } else {
                owner.splitDirectionView.isHidden = true
            }
        }.disposed(by: disposeBag)
    }

    func didSelectableViewTouched(selectableType: SelectableType, stationName: String?) {
        guard let direction = selectableType as? UpDownDirection,
              let stationName
        else { return }
        viewModel.didSelectDirection(direction: direction, stationName: stationName)
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }

}
