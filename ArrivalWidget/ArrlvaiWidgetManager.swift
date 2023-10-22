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
        timer: ClosedRange<Date>
    ) {
        guard ActivityAuthorizationInfo().areActivitiesEnabled else { return }
        // widget attribute, contentState 생성
        let attributes = ArrivalWidgetAttributes()
        let state = ArrivalWidgetAttributes.ContentState(
            timer: timer,
            stationName: stationName,
            stationLine: stationLine,
            stationLineColorName: stationLineColorName,
            nextStation: nextStation
        )

        if activity != nil {
            Task {
                await activity?.update(using: state)
            }
        } else {
            do {
                // live activity 시작
                self.activity = try Activity.request(
                    attributes: attributes,
                    content: .init(state: state, staleDate: nil)
                )
            } catch {
                print(error)
            }
        }
    }

    func stop() {
        Task {
            await activity?.end(dismissalPolicy: .immediate)
            activity = nil
        }
    }
}
