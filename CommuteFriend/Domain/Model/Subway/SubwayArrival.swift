//
//  SubwayArrival.swift
//  CommuteMate
//
//  Created by 박태현 on 2023/09/25.
//

import Foundation

struct SubwayArrival: Hashable {
    var destination: String // ~ 행
    let arrivalMessage: String // 도착까지 남은 시간 or 전역 출발
    let remainTimeForSecond: String // 남은 시간(초)
    let currentStation: String // 현재 위치
    let nextStation: String // 다음역
    let subwayLine: SubwayLine? // 호선 정보
    let creationDate: String // 데이터 생성 시각
    let arrivalCode: SubwayArrivalCode?
    let upDownLine: UpDownDirection
    let ordkey: String

    init(
        direction: String,
        arrivalMessage: String,
        remainTimeForSecond: String,
        currentStation: String,
        nextStation: String,
        subwayLine: String,
        creationDate: String,
        arrivalCode: String,
        upDownLine: String,
        ordkey: String
    ) {
        self.destination = direction
        self.arrivalMessage = arrivalMessage
        self.remainTimeForSecond = remainTimeForSecond
        self.currentStation = currentStation
        self.nextStation = nextStation
        self.subwayLine = SubwayLine(rawValue: subwayLine)
        self.creationDate = creationDate
        self.arrivalCode = SubwayArrivalCode(rawValue: arrivalCode)
        self.upDownLine = UpDownDirection(rawValue: upDownLine) ?? .up
        self.ordkey = ordkey
    }
}

extension SubwayArrival {

    var arrivalTimeDescription: String {

        guard remainSecond > 0 else {
            return "도착"
        }

        return String(remainSecond).toArrivalTimeFormString()
    }

    /// 지하철 도착까지 남은 시간을 초 단위로 반환합니다.
    var remainSecond: Int {
        // API 데이터 생성 시간
        guard let creationDate = creationDate.toDate() else { return 0 }

        // API 데이터 생성 시간으로부터 현재까지의 시간차이
        let term = Int(Date.now.timeIntervalSince(creationDate))

        // 남은 시간(초)
        guard let remainTimeForSecond = Int(remainTimeForSecond) else { return 0 }

        // 남은 시간(초) 에서 term을 빼서 대략적인 도착 시간 계산
        let calculatedTime = remainTimeForSecond - term

        return calculatedTime > 0 ? calculatedTime : 0
    }

    /**
    지하철 도착까지 남은 시간을 출력을 위한 형태로 변환해서 반환합니다.

    지하철 도착까지 3분 이상 남았다면,  "@분 후" 로 변환합니다.
    지하철 도착까지 2분 이하 남았다면, 지하철의 상태코드로 변환합니다.(전역출발, 진입중 등)

     - Returns: "@@분" || "상태코드"
    */
    var remainTimeSecond: String {
        // API 데이터 생성 시간
        guard let creationDate = creationDate.toDate() else { return "0" }

        // API 데이터 생성 시간으로부터 현재까지의 시간차이
        let term = Int(Date.now.timeIntervalSince(creationDate))

        // 남은 시간(초)
        guard let remainTimeForSecond = Int(remainTimeForSecond) else { return "0" }

        // 남은 시간(초) 에서 term을 빼서 대략적인 도착 시간 계산
        let calculatedTime = remainTimeForSecond - term
        let result = calculatedTime > 0 ? String(calculatedTime) : "0"

        // 1분 이상 남았을 경우 "*분 후"로 표기
        if calculatedTime > 60 {
            return result.toArrivalTimeFormString()
        }
        // 1분 미만일 경우, "곧 도착" 또는 도착 코드에 의한 표기
        else if let arrivalCode {
            if arrivalCode == .move {
                return "곧 도착"
            }
            return arrivalCode.description
        }
        return ""
        // return result > 0 ? String(result).toArrivalTimeFormString() : "0".toHourMinSecString()
    }

    /**
    [상태코드 축약형] 지하철 도착까지 남은 시간을 출력을 위한 형태로 변환해서 반환합니다.

    지하철 도착까지 3분 이상 남았다면,  "@분 후" 로 변환합니다.
    지하철 도착까지 2분 이하 남았다면, 지하철의 상태코드로 변환합니다.(전역출발, 진입중 등)

     - Returns: "@@분" || "상태코드"
    */
    var conveniencedRemainTimeSecond: String {
        // API 데이터 생성 시간
        guard let creationDate = creationDate.toDate() else { return "0" }

        // API 데이터 생성 시간으로부터 현재까지의 시간차이
        let term = Int(Date.now.timeIntervalSince(creationDate))

        // 남은 시간(초)
        guard let remainTimeForSecond = Int(remainTimeForSecond) else { return "0" }

        // 남은 시간(초) 에서 term을 빼서 대략적인 도착 시간 계산
        let calculatedTime = remainTimeForSecond - term
        let result = calculatedTime > 0 ? String(calculatedTime) : "0"

        // 1분 이상 남았을 경우 "*분 후"로 표기
        if calculatedTime > 60 {
            return result.toArrivalTimeFormString()
        }
        // 1분 미만일 경우, "곧 도착" 또는 도착 코드에 의한 표기
        else if let arrivalCode {
            if arrivalCode == .move {
                return "곧 도착"
            }
            return arrivalCode.shortDescription
        }
        return ""
        // return result > 0 ? String(result).toArrivalTimeFormString() : "0".toHourMinSecString()
    }
}
