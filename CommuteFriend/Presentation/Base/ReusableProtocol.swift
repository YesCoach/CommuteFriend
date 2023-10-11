//
//  ReusableProtocol.swift
//  CommuteMate
//
//  Created by 박태현 on 2023/09/25.
//

import Foundation

protocol ReusableProtocol: AnyObject {
    static var reuseIdentifier: String { get }
}

extension BaseViewController: ReusableProtocol { }
extension BaseCollectionViewCell: ReusableProtocol { }
extension BaseTableViewCell: ReusableProtocol { }

extension ReusableProtocol {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
