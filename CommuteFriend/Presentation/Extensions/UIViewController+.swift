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

}
