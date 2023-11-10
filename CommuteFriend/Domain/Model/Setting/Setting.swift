//
//  Setting.swift
//  CommuteFriend
//
//  Created by 박태현 on 2023/11/10.
//

import Foundation

enum Setting: CaseIterable {

    // MARK: - 앱 정보

    case appVersion
    case appInfo
    case privacyInfo
    case openSourceLicense
    case dataSourceInfo

    // MARK: - 기타

    case inquiry
    case share

    var description: String {
        switch self {
        case .appVersion: return "버전"
        case .appInfo: return "공지사항"
        case .privacyInfo: return "개인정보 처리방침"
        case .openSourceLicense: return "오픈소스 라이선스"
        case .dataSourceInfo: return "데이터 출처"
        case .inquiry: return "문의하기"
        case .share: return "공유하기"
        }
    }

    var accessory: String {
        switch self {
        case .appVersion: return ""
        case .appInfo: return "📣"
        case .privacyInfo: return "📝"
        case .openSourceLicense: return "🪪"
        case .dataSourceInfo: return "📈"
        case .inquiry: return "📨"
        case .share: return "🧸"
        }
    }
}
