//
//  DateFormatter+.swift
//  CommuteFriend
//
//  Created by 박태현 on 2023/10/11.
//

import Foundation

extension DateFormatter {

    static let dateFormatHourMinute = {
        let format = DateFormatter()
        format.dateFormat = "hh:mm"
        return format
    }()

    static let dateFormatFull = {
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return format
    }()

    static func convertDate(date: Date) -> String {
        return dateFormatHourMinute.string(from: date)
    }

}
