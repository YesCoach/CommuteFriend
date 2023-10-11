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
    }

    func configureUI() { }

    func configureLayout() { }

}
