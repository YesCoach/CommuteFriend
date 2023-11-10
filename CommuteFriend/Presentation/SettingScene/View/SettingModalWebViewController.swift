//
//  SettingModalWebViewController.swift
//  CommuteFriend
//
//  Created by 박태현 on 2023/11/11.
//

import UIKit
import WebKit
import RxSwift

final class SettingModalWebViewController: BaseViewController {

    // MARK: - View

    private lazy var webView: WKWebView = {
        let config = WKWebViewConfiguration()
        let webView = WKWebView(frame: .zero, configuration: config)
        return webView
    }()

    private lazy var indicatorView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.hidesWhenStopped = true
        view.style = .medium
        return view
    }()

    // MARK: - Properties

    private let disposeBag = DisposeBag()
    private let viewModel: SettingModalWebViewModel

    // MARK: - Initializer

    init(viewModel: SettingModalWebViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        bind()

        if let request = viewModel.settingItemURLRequest {
            webView.load(request)
        }
    }

    override func configureLayout() {
        [
            webView, indicatorView
        ].forEach { view.addSubview($0) }

        webView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        indicatorView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }

    private func bind() {
        webView.rx.didStartLoad
            .map { _ in true }
            .bind(to: indicatorView.rx.isAnimating)
            .disposed(by: disposeBag)

        webView.rx.didCommit
            .map { _ in false }
            .bind(to: indicatorView.rx.isAnimating)
            .disposed(by: disposeBag)

        webView.rx.didFailLoad
            .map { $0.1 }
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, error in
                print(error.localizedDescription)
                owner.indicatorView.rx.isAnimating.onNext(false)
                owner.presentAlert(title: "페이지 로드 오류", message: "연결 상태를 확인해주세요!")
            }
            .disposed(by: disposeBag)
    }

}
