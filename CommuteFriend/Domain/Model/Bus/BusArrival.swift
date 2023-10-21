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
    let latPos: Double
    let lonPos: Double
    let firstArrivalSec: Int
    let secondArrivalSec: Int
    let dataCreationTime: Date
}

extension BusArrival {

    var firstCaculatedeTime: Int {
        let time = self.firstArrivalSec
        let term = Int(Date.now.timeIntervalSince(dataCreationTime))
        let calculatedTime = time - term
        return calculatedTime
    }

    var secondCaculatedeTime: Int {
        let time = self.secondArrivalSec
        let term = Int(Date.now.timeIntervalSince(dataCreationTime))
        let calculatedTime = time - term
        return calculatedTime
    }

    /// 첫번째 버스 도착 예정 메시지를 포맷합니다.
    ///
    /// - Returns:
    ///     - 남은 시간이 0일 경우 메세지 그대로 반환
    ///     - 0이 아닐경우, API 생성 시간으로 부터 현재 시간을 뺀 값을 남은시간에 빼서 반환
    var firstArrivalTimeDescription: String {

        guard firstArrivalSec != 0 else {
            return firstArrivalMessage
        }

        if firstCaculatedeTime < 30 {
            return "곧 도착"
        }

        if firstCaculatedeTime <= 0 {
            return "도착"
        }

        return String(firstCaculatedeTime).toArrivalTimeFormString()
    }

    /// 두번째 버스 도착 예정 메시지를 포맷합니다.
    ///
    /// - Returns:
    ///     - 남은 시간이 0일 경우 메세지 그대로 반환
    ///     - 0이 아닐경우, API 생성 시간으로 부터 현재 시간을 뺀 값을 남은시간에 빼서 반환
    var secondArrivalTimeDescription: String {

        guard secondArrivalSec != 0 else {
            return secondArrivalMessage
        }

        if secondCaculatedeTime < 30 {
            return "곧 도착"
        }

        if secondCaculatedeTime <= 0 {
            return "도착"
        }

        return String(secondCaculatedeTime).toArrivalTimeFormString()
    }

}
