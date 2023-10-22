//
//  ArrlvaiWidgetManager.swift
//  CommuteFriend
//
//  Created by 박태현 on 2023/10/21.
//

import SwiftUI
import ActivityKit

final class ArrivalWidgetManager: ObservableObject {
    static let shared = ArrivalWidgetManager()

    @Published var activity: Activity<ArrivalWidgetAttributes>?

    private init() {}

    func start(
        stationName: String,
        stationLine: String,
        stationLineColorName: String,
        nextStation: String,
        timer: Date
    ) {
        guard ActivityAuthorizationInfo().areActivitiesEnabled else { return }

        let attributes = ArrivalWidgetAttributes(
            stationName: stationName,
            stationLine: stationLine,
            stationLineColorName: stationLineColorName,
            nextStation: nextStation
        )
        let state = ArrivalWidgetAttributes.ContentState(timer: timer)

        do {
            // live activity 시작
            self.activity = try Activity.request(attributes: attributes, contentState: state)
        } catch {
            print(error)
        }
    }

    func stop() {
        Task {
            for activity in Activity<ArrivalWidgetAttributes>.activities {
                await activity.end(dismissalPolicy: .immediate)
            }
        }
    }
}
