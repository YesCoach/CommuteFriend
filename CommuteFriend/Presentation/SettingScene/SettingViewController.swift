//
//  SettingViewController.swift
//  CommuteFriend
//
//  Created by 박태현 on 2023/10/22.
//

import UIKit

final class SettingViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let subwayTrain = UIImageView(image: .init(systemName: "train.side.front.car"))
        subwayTrain.frame = CGRect(x: -100, y: 100, width: 50, height: 25)
        subwayTrain.tintColor = .systemRed
        view.addSubview(subwayTrain)

        UIView.animate(withDuration: 3.0, delay: 0, options: .repeat) {
            subwayTrain.frame.origin.x = self.view.frame.size.width
        } completion: { bool in
            print("Ani Complet")
        }
    }

    override func configureUI() {
        super.configureUI()
        view.backgroundColor = .systemBackground
    }
}
