//
//  String+.swift
//  CommuteFriend
//
//  Created by 박태현 on 2023/10/11.
//

import Foundation

extension String {

    func toArrivalTimeFormString() -> String {
        let timeData = Int(self) ?? 0
        let hourTime = timeData / 3600
        let minTime = timeData / 60
        /*
        let secTime = timeData % 60
         */

        var result = ""
        if hourTime != 0 {
            result += "\(hourTime)시간 "
        }
        if minTime != 0 {
            result += "\(minTime)분 "
        }

        /*
        if secTime != 0 {
            result += "\(secTime)초 "
        }
         */

        if timeData == 0 {
            result = "도착"
        } else {
            result += "후"
        }

        return result
    }

    func toDate() -> Date? {
        return DateFormatter.dateFormatFull.date(from: self)
    }

}
