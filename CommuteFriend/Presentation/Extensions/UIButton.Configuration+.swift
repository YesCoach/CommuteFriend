//
//  UIButton.Configuration+.swift
//  CommuteFriend
//
//  Created by 박태현 on 2023/10/11.
//

import UIKit.UIButtonConfiguration

extension UIButton.Configuration {

    static func filledCapsuleConfiguration(
        foregroundColor: UIColor,
        backgroundColor: UIColor
    ) -> UIButton.Configuration {
        var configuration = UIButton.Configuration.filled()
        configuration.baseForegroundColor = .white
        configuration.baseBackgroundColor = backgroundColor
        configuration.cornerStyle = .capsule
        configuration.buttonSize = .mini

        return configuration
    }

    static func enrollButtonConfiguration(
        foregroundColor: UIColor,
        backgroundColor: UIColor
    ) -> UIButton.Configuration {
        var configuration = UIButton.Configuration.filled()
        configuration.baseForegroundColor = .white
        configuration.baseBackgroundColor = backgroundColor
        configuration.cornerStyle = .large

        return configuration
    }

}
