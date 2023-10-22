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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let subwayTrain = UIImageView(image: .init(systemName: "train.side.front.car"))
        subwayTrain.frame = CGRect(x: -100, y: 100, width: 50, height: 25)
        subwayTrain.tintColor = .systemRed
        view.addSubview(subwayTrain)

//        let subwayTrain = CALayer()
        let animation = CABasicAnimation(keyPath: "position.x")
        animation.fromValue = -100
        animation.toValue = view.frame.size.width + 100
        animation.duration = 10.0
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        animation.isRemovedOnCompletion = false
        animation.repeatCount = 10
        animation.fillMode = .forwards

        UIView.animate(withDuration: 5.0, animations: {
            subwayTrain.frame.origin.x = self.view.frame.size.width
        }) { (_) in
            subwayTrain.removeFromSuperview() // Remove the train when the animation is complete
        }


//        subwayTrain.add(animation, forKey: "subwayAnimation")

    }

    override func configureUI() {
        super.configureUI()
        view.backgroundColor = .systemBackground
    }
}
