//
//  BaseViewController.swift
//  CommuteMate
//
//  Created by 박태현 on 2023/09/25.
//

import UIKit
import SnapKit

class BaseViewController: UIViewController {

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureLayout()
        configureNavigationItem()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NetworkCheckManager.shared.completion = { [weak self] isNetworkNotWork in
            if isNetworkNotWork {
                DispatchQueue.main.async { [self] in
                    self?.presentAlert(
                        title: "네트워크 연결 오류!",
                        message: "네트워크 연결 상태를 확인해주세요"
                    )
                }
            }
        }
        NetworkCheckManager.shared.checkNetwork()
    }

    func configureUI() { }

    func configureLayout() { }

    func configureNavigationItem() { }

    deinit {
        print("🗑️: \(String(describing: type(of: self))) deinit!")
    }

}
