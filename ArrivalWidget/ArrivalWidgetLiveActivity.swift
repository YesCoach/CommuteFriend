//
//  ArrivalWidgetLiveActivity.swift
//  ArrivalWidget
//
//  Created by 박태현 on 2023/10/21.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct ArrivalWidgetAttributes: ActivityAttributes {

    enum TransportType: String, Codable {
        case subway
        case bus
    }

    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var timer: ClosedRange<Date>
        var stationName: String
        var stationLine: String
        var stationLineColorName: String
        var nextStation: String
        var type: TransportType
    }

    // Fixed non-changing properties about your activity go here!
}

struct ArrivalWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: ArrivalWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            ArrivalWidgetLiveActivityView(context: context)
        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.bottom) {
                    VStack() {
                        Spacer(minLength: 5)
                        HStack(alignment: .bottom, spacing: 10.0) {
                            Spacer().frame(width: 5)
                            Button("\(context.state.stationLine)") { }
                                .buttonStyle(
                                    InsetRoundButton(
                                        labelColor: .white,
                                        backgroundColor: .init(context.state.stationLineColorName)
                                    )
                                )
                            Text("\(context.state.stationName)")
                                .foregroundColor(.white)
                                .font(.system(size: 22.0, weight: .bold))
                            Spacer(minLength: 2.0)
                            Text("\(context.state.nextStation) 방면")
                                .foregroundColor(.white)
                                .font(.system(size: 14.0, weight: .bold))
                            Spacer().frame(width: 5)
                        }
                        HStack(spacing: 5.0) {
                            Spacer()
                            Text("도착까지 ")
                                .font(.system(size: 22.0, weight: .semibold))
                                .foregroundColor(.white)
                            Text(timerInterval: context.state.timer, countsDown: true)
                                .multilineTextAlignment(.center)
                                .monospacedDigit()
                                .font(.system(size: 30, weight: .semibold))
                                .foregroundStyle(Color.activityText)
                                .frame(width: 100)
                            Spacer()
                        }
                        Spacer(minLength: 5)
                    }
                }
            } compactLeading: {
                switch context.state.type {
                case .subway:
                    Image(uiImage: .init(systemName: "tram.fill") ?? .add)
                        .renderingMode(.template)
                        .colorMultiply(Color("\(context.state.stationLineColorName)"))
                        .fixedSize()
                case .bus:
                    Image(uiImage: .init(systemName: "bus.fill") ?? .add)
                        .renderingMode(.template)
                        .colorMultiply(Color("\(context.state.stationLineColorName)"))
                        .fixedSize()
                }
            } compactTrailing: {
                Text(timerInterval: context.state.timer, countsDown: true)
                    .monospacedDigit()
                    .frame(width: 52)
                    .font(.system(size: 13.0, weight: .semibold))
                    .foregroundColor(.white)
            } minimal: {
                switch context.state.type {
                case .subway:
                    Image(uiImage: .init(systemName: "tram.fill") ?? .add)
                        .renderingMode(.template)
                        .colorMultiply(Color("\(context.state.stationLineColorName)"))
                        .fixedSize()
                case .bus:
                    Image(uiImage: .init(systemName: "bus.fill") ?? .add)
                        .renderingMode(.template)
                        .colorMultiply(Color("\(context.state.stationLineColorName)"))
                        .fixedSize()
                }
            }
        }
    }

}
