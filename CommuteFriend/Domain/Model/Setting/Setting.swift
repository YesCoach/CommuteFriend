//
//  Setting.swift
//  CommuteFriend
//
//  Created by 박태현 on 2023/11/10.
//

import Foundation
import RxDataSources

protocol SettingItem {
    var description: String { get }
    var accessory: String { get }
    var url: String? { get }
}

enum Setting: SectionModelType, CaseIterable {

    init(original: Setting, items: [SettingItem]) {
        self = original
    }

    case info
    case others

    var header: String {
        switch self {
        case .info: return "앱 정보"
        case .others: return "기타"
        }
    }

    var itemsCount: Int {
        switch self {
        case .info: return InfoSection.allCases.count
        case .others: return Others.allCases.count
        }
    }

    var items: [SettingItem] {
        switch self {
        case .info: return InfoSection.allCases
        case .others: return Others.allCases
        }
    }

    // MARK: - 앱 정보

    enum InfoSection: SettingItem, CaseIterable {
        case appVersion
        case appInfo
        case privacyInfo
        case openSourceLicense
        case dataSourceInfo

        var description: String {
            switch self {
            case .appVersion: return "버전 \(Setting.currentAppVersion())"
            case .appInfo: return "공지사항"
            case .privacyInfo: return "개인정보 처리방침"
            case .openSourceLicense: return "오픈소스 라이선스"
            case .dataSourceInfo: return "데이터 출처"
            }
        }

        var accessory: String {
            switch self {
            case .appVersion: return ""
            case .appInfo: return "📣"
            case .privacyInfo: return "📝"
            case .openSourceLicense: return "🪪"
            case .dataSourceInfo: return "📈"
            }
        }

        var url: String? {
            switch self {
            case .appVersion: return nil
            case .appInfo:
                return "https://yescoach.notion.site/8dafb60f0f4548d6bff3f4405409091f?pvs=4"
            case .privacyInfo:
                return "https://yescoach.notion.site/f8f9250a0eb14a86a9ee513c7ee84692?pvs=4"
            case .openSourceLicense:
                return "https://yescoach.notion.site/03f094b7dada422a851bea3821f5524f?pvs=4"
            case .dataSourceInfo:
                return "https://yescoach.notion.site/92987d2042504a76b4688812faee9d00?pvs=4"
            }
        }
    }

    // MARK: - 기타

    enum Others: SettingItem, CaseIterable {
        case inquiry
        case share

        var description: String {
            switch self {
            case .inquiry: return "문의하기"
            case .share: return "공유하기"
            }
        }

        var accessory: String {
            switch self {
            case .inquiry: return "📨"
            case .share: return "🧸"
            }
        }

        var url: String? {
            return nil
        }
    }

}

extension Setting {

    static func currentAppVersion() -> String {
        if let info: [String: Any] = Bundle.main.infoDictionary,
           let currentVersion: String = info["CFBundleShortVersionString"] as? String {
            return currentVersion
        }
        return "nil"
    }

}
