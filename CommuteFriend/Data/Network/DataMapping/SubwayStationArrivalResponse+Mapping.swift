//
//  SubwayStationArrivalResponse+Mapping.swift
//  CommuteFriend
//
//  Created by 박태현 on 2023/10/15.
//

import Foundation

struct SubwayStationArrivalResponseDTO: DTOMapping {
    typealias DomainType = [SubwayArrival]

    let realtimeArrivalList: [SubwayStationArrivalDTO]?

    func toDomain() -> DomainType {
        guard let realtimeArrivalList else { return [] }
        return realtimeArrivalList.map { $0.toDomain() }
    }

}

struct SubwayStationArrivalDTO: DTOMapping {
    typealias DomainType = SubwayArrival

    let line: String // @@행 - @@방면
    let arrivalMessage: String // 도착까지 남은 시간 or 전역 출발
    let remainTimeForSecond: String // 남은 시간(초)
    let currentStation: String // 현재 위치
    let subwayID: String // 호선 id
    let creationDate: String // 데이터 생성 시각
    let arrivalCode: String // 도착 코드
    let updnLine: String // 상하행 구분 - "상행" "하행"
    let ordkey: String // 도착 순서 코드

    enum CodingKeys: String, CodingKey {
        case line = "trainLineNm"
        case arrivalMessage = "arvlMsg2"
        case remainTimeForSecond = "barvlDt"
        case currentStation = "arvlMsg3"
        case subwayID = "subwayId"
        case creationDate = "recptnDt"
        case arrivalCode = "arvlCd"
        case updnLine
        case ordkey
    }

    func toDomain() -> DomainType {
        /// @@ 행
        let trimmedline = line.components(separatedBy: " ").first
        /// @@ 방면
        let destination = line.components(separatedBy: " ")[safe: 2]?
            .components(separatedBy: "방면").first

        // 남은 시간을 제공하지 않는 수도권 노선에 활용할 도착 메시지 구성
        var arrivalMessageFixed = arrivalMessage
            .replacingOccurrences(of: "[\\[\\]]", with: "", options: .regularExpression)
            .components(separatedBy: "(").first?
            .trimmingCharacters(in: .whitespaces)

        print("\(arrivalMessageFixed) <- \(arrivalMessage)")

        return DomainType(
            direction: trimmedline ?? line,
            arrivalMessage: arrivalMessageFixed ?? arrivalMessage,
            remainTimeForSecond: remainTimeForSecond,
            currentStation: currentStation,
            nextStation: destination ?? "",
            subwayLine: subwayID,
            creationDate: creationDate,
            arrivalCode: arrivalCode,
            upDownLine: updnLine,
            ordkey: ordkey
        )
    }

}
