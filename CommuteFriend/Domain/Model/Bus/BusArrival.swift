//
//  BusArrival.swift
//  CommuteMate
//
//  Created by 박태현 on 2023/09/30.
//

import Foundation

struct BusArrival: Hashable {
    let stationID: String // arsID: 정류소 번호
    let stationName: String
    let busRouteID: String
    let busRouteName: String // busRouteAbrv: 노선 약칭
    let busRouteType: String
    let term: String
    let direction: String
    let nextStationName: String
    let firstArrivalMessage: String
    let secondArrivalMessage: String
}

extension BusArrival {

    /// 버스 도착 예정 메시지를 포맷합니다.
    ///
    /// - Returns:
    ///     - "곧 도착", "출발예정" 등 텍스트일 경우 그대로 반환
    ///     - "@@분 ##초후..." 형태일 경우 @@분만 따로 빼서 반환

    var firstArrivalTime: String {
        let message = self.firstArrivalMessage
        if message.contains("후") {
            let minute = message.components(separatedBy: "후").first!
                .components(separatedBy: "분").first!
            return "약 \(minute)분"
        } else {
            if message.contains("차고지") {
                return "도착정보없음"
            }
            return message
        }
    }

    /// 버스 도착 예정 메시지를 포맷합니다.
    ///
    /// - Returns:
    ///     - "곧 도착", "출발예정" 등 텍스트일 경우 nil 반환
    ///     - "@@분 ##초후..." 형태일 경우 "[$번째 전]" 반환
    var firstArrivalMsg: String? {
        let message = self.firstArrivalMessage
        if message.contains("후") {
            let msg = message.components(separatedBy: "후").last!
            return msg
        } else {
            return nil
        }
    }

    /// 버스 도착 예정 메시지를 포맷합니다.
    ///
    /// - Returns:
    ///     - "곧 도착", "출발예정" 등 텍스트일 경우 그대로 반환
    ///     - "@@분 ##초후..." 형태일 경우 @@분만 따로 빼서 반환

    var secondArrivalTime: String {
        let message = self.secondArrivalMessage
        if message.contains("후") {
            let minute = message.components(separatedBy: "후").first!
                .components(separatedBy: "분").first!
            return "약 \(minute)분"
        } else {
            if message.contains("차고지") {
                return "도착정보없음"
            }
            return message
        }
    }

    /// 버스 도착 예정 메시지를 포맷합니다.
    ///
    /// - Returns:
    ///     - "곧 도착", "출발예정" 등 텍스트일 경우 nil 반환
    ///     - "@@분 ##초후..." 형태일 경우 "[$번째 전]" 반환
    var secondArrivalMsg: String? {
        let message = self.secondArrivalMessage
        if message.contains("후") {
            let msg = message.components(separatedBy: "후").last!
            return msg
        } else {
            return nil
        }
    }
}
