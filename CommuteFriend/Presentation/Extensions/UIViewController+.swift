//
//  UIViewController+.swift
//  CommuteFriend
//
//  Created by 박태현 on 2023/10/12.
//

import UIKit

extension UIViewController {

    func deinitPrint() {
        print("🗑️: \(String(describing: type(of: self))) deinit!")
    }

    func presentAlert(title: String?, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .default)

        alert.addAction(action)
        present(alert, animated: true)
    }

}
