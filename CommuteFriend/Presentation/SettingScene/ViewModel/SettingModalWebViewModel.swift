//
//  SettingModalWebViewModel.swift
//  CommuteFriend
//
//  Created by 박태현 on 2023/11/11.
//

import Foundation

final class SettingModalWebViewModel {

    let settingItemURLRequest: URLRequest?

    private let settingItem: SettingItem

    init(settingItem: SettingItem) {
        self.settingItem = settingItem
        if let url = URL(string: settingItem.url ?? "") {
            self.settingItemURLRequest = URLRequest(url: url)
        } else {
            self.settingItemURLRequest = nil
        }
    }

}
