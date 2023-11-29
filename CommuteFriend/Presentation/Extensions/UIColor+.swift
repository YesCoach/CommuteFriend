//
//  UIColor+.swift
//  CommuteFriend
//
//  Created by 박태현 on 2023/10/12.
//

import UIKit.UIColor

extension UIColor {

    static func subwayLineColor(_ line: SubwayLine) -> UIColor {
        return UIColor(named: "\(line.rawValue)") ?? .cyan
    }

    static func busTypeColor(_ busType: BusType) -> UIColor {
        return UIColor(named: "\(busType.description)") ?? .cyan
    }

    static var mainBackgroundColor: UIColor {
        return UIColor(named: "BackgroundColor") ?? .systemBackground
    }

    static var selectionColor: UIColor {
        return UIColor(named: "SelectionColor") ?? .systemBackground
    }

    static var buttonColor: UIColor {
        return UIColor(named: "ButtonColor") ?? .systemBlue
    }

}
