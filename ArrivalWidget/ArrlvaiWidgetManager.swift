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
        timer: ClosedRange<Date>,
        type: ArrivalWidgetAttributes.TransportType
    ) {
        guard ActivityAuthorizationInfo().areActivitiesEnabled else { return }
        // widget attribute, contentState 생성
        let attributes = ArrivalWidgetAttributes()
        let state = ArrivalWidgetAttributes.ContentState(
            timer: timer,
            stationName: stationName,
            stationLine: stationLine,
            stationLineColorName: stationLineColorName,
            nextStation: nextStation,
            type: type
        )

        // 사용자가 종료했거나 오래된 경우
        if [ ActivityState.dismissed, .ended, .stale].contains(
            activity?.activityState
        ) {
            do {
                // live activity 시작
                print("액티비티 시작")
                self.activity = try Activity.request(
                    attributes: attributes,
                    content: .init(state: state, staleDate: nil)
                )
            } catch {
                debugPrint(error)
            }
        } else {
            if activity != nil {
                Task {
                    print("액티비티 업데이트")
                    await activity?.update(using: state)
                }
            } else {
                do {
                    // live activity 시작
                    print("액티비티 시작")
                    self.activity = try Activity.request(
                        attributes: attributes,
                        content: .init(state: state, staleDate: nil)
                    )
                } catch {
                    debugPrint(error)
                }
            }
        }
    }

    func stop() {
        Task {
            await activity?.end(dismissalPolicy: .immediate)
            for activity in Activity<ArrivalWidgetAttributes>.activities {
                await activity.end(dismissalPolicy: .immediate)
            }
        }
    }
}
