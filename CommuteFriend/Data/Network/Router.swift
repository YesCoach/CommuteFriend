//
//  Router.swift
//  CommuteFriend
//
//  Created by 박태현 on 2023/10/11.
//

import Foundation
import Alamofire

enum NetworkError: Int, Error, LocalizedError {
    case unknownError = 0
    case invalidURL = 1
    case decodeFailed = 2
    case invalidRequest = 400
    case unauthorized = 401
    case permissionDenied = 403
    case invalidServer = 500

    var errorDescription: String {
        switch self {
        case .unknownError:
            return "미분류 에러입니다"
        case .invalidURL:
            return "유효하지 않은 URL입니다"
        case .decodeFailed:
            return "디코딩을 실패했습니다"
        case .invalidRequest:
            return "잘못된 요청입니다"
        case .unauthorized:
            return "인증 정보가 없습니다"
        case .permissionDenied:
            return "권한이 없습니다"
        case .invalidServer:
            return "서버 점검 중입니다"
        }
    }
}

enum Router: URLRequestConvertible {

    case subwayStationInfo(query: String)
    case subwayStationArrivalInfo(query: String)
    case busInfo(query: String)
    case busStationInfo(query: String)
    case busStationByRoute(query: String)
    case busRouteByStation(query: String)
    case busStationArrivalInfo(query: String)

    private var baseURL: URL? {
        switch self {
        case .subwayStationInfo:
            return URL(string: "http://openAPI.seoul.go.kr:8088/")
        case .subwayStationArrivalInfo:
            return URL(string: "http://swopenapi.seoul.go.kr/api/subway/")
        case .busInfo,
                .busStationInfo,
                .busStationByRoute,
                .busRouteByStation,
                .busStationArrivalInfo:
            return URL(string: "http://ws.bus.go.kr/api/rest/")
        }
    }

    private var path: String {
        switch self {
        case .subwayStationInfo(let query):
            return "\(apiKey)/json/SearchInfoBySubwayNameService/0/100/\(query)"
        case .subwayStationArrivalInfo(let query):
            return "\(apiKey)/json/realtimeStationArrival/0/50/\(query)"
//            return "sample/json/realtimeStationArrival/0/5/\(query)"
        case .busStationInfo:
            return "stationinfo/getStationByName"
        case .busStationArrivalInfo:
            return "stationinfo/getStationByUid"
        case .busInfo:
            return "busRouteInfo/getBusRouteList"
        case .busStationByRoute:
            return "busRouteInfo/getStaionByRoute"
        case .busRouteByStation:
            return "stationinfo/getRouteByStation"
        }
    }

    private var header: HTTPHeaders? {
        switch self {
        default: return nil
        }
    }

    private var apiKey: String {
        switch self {
        case .subwayStationInfo: return APIKey.Subway.stationNameService
        case .subwayStationArrivalInfo:
            let apiKey =
            [
                APIKey.Subway.arrivalService, APIKey.Subway.arrivalServiceTemp1,
                APIKey.Subway.arrivalServiceTemp2, APIKey.Subway.arrivalServiceTemp3,
                APIKey.Subway.arrivalServiceTemp4, APIKey.Subway.arrivalServiceTemp5,
                APIKey.Subway.arrivalServiceTemp6
            ].randomElement()!
            return apiKey
        case .busInfo,
                .busStationInfo,
                .busStationByRoute,
                .busRouteByStation,
                .busStationArrivalInfo:
            return APIKey.Bus.service
        default: return "sample"
        }
    }

    private var method: HTTPMethod {
        return .get
    }

    private var query: [String: String] {
        switch self {
        case .subwayStationInfo, .subwayStationArrivalInfo: return [:]
        case .busInfo(let query):
            return [
                "serviceKey": apiKey,
                "strSrch": query,
                "resultType": "json"
            ]
        case .busStationInfo(let query):
            return [
                "serviceKey": apiKey,
                "stSrch": query,
                "resultType": "json"
            ]
        case .busStationByRoute(let query):
            return [
                "serviceKey": apiKey,
                "busRouteId": query,
                "resultType": "json"
            ]
        case .busRouteByStation(let query):
            return [
                "serviceKey": apiKey,
                "arsId": query,
                "resultType": "json"
            ]
        case .busStationArrivalInfo(let query):
            return [
                "serviceKey": apiKey,
                "arsId": query,
                "resultType": "json"
            ]
        }
    }

    func asURLRequest() throws -> URLRequest {

        guard let baseURL else { throw NetworkError.invalidURL }

        let url = baseURL.appendingPathComponent(path)

        var request = URLRequest(url: url)
        if let header {
            request.headers = header
        }
        request.method = method

        // 쿼리 정보를 파라미터에 추가
        // destination: 파라미터로 추가하고자 하는 쿼리의 위치(타깃) - httpBody, query 등
        request = try URLEncodedFormParameterEncoder(
            destination: .methodDependent
        ).encode(query, into: request)

        print(request)
        return request
    }

}
