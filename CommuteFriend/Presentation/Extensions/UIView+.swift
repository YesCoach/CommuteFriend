//
//  UIView+.swift
//  CommuteFriend
//
//  Created by 박태현 on 2023/10/18.
//

import UIKit.UIView

extension UIView {

    func setViewShadow(backView: UIView) {
        backView.layer.masksToBounds = true
        backView.layer.cornerRadius = 10

        layer.masksToBounds = false
        layer.shadowOpacity = 0.8
        layer.shadowOffset = CGSize(width: -2, height: 2)
        layer.shadowRadius = 3
    }

}
