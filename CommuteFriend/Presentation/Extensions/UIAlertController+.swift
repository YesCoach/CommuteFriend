//
//  UIAlertController+.swift
//  CommuteFriend
//
//  Created by 박태현 on 2023/10/23.
//

import UIKit.UIAlertController

extension UIAlertController {

    static func simpleConfirmAlert(title: String = "", message: String = "") -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .default)

        alert.addAction(action)
        return alert
    }
}
