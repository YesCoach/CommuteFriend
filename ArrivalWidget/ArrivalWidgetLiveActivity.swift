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
                        HStack(spacing: 5) {
                            Spacer().frame(width: 15)
                            Button("\(context.state.stationLine)") { }
                                .buttonStyle(
                                    InsetRoundButton(
                                        labelColor: .white,
                                        backgroundColor: .init(context.state.stationLineColorName)
                                    )
                                )
                            Text("\(context.state.stationName)")
                                .foregroundColor(.white)
                                .font(.system(size: 24.0, weight: .bold))
                            Text("\(context.state.nextStation) 방면")
                                .foregroundColor(.white)
                            Spacer()
                        }
                        HStack(spacing: 5.0) {
                            Spacer()
                            Text("도착까지 ")
                                .font(.system(size: 30, weight: .semibold))
                                .foregroundColor(.white)
                            Text(timerInterval: context.state.timer, countsDown: true)
                                .multilineTextAlignment(.center)
                                .monospacedDigit()
                                .font(.system(size: 44, weight: .semibold))
                                .foregroundColor(Color(uiColor: .systemGreen) .opacity(0.8))
                            Spacer()
                        }
                        Spacer(minLength: 5)
                    }
                    .background(.black.opacity(0.8))

                }
            } compactLeading: {
                switch context.state.type {
                case .subway:
                    Image(uiImage: .init(systemName: "tram.fill") ?? .add)
                        .renderingMode(.template)
                        .colorMultiply(Color("\(context.state.stationLineColorName)"))
                case .bus:
                    Image(uiImage: .init(systemName: "bus.fill") ?? .add)
                        .renderingMode(.template)
                        .colorMultiply(Color("\(context.state.stationLineColorName)"))
                }
            } compactTrailing: {
                Text(timerInterval: context.state.timer, countsDown: true)
                    .monospacedDigit()
                    .frame(width: 50)
                    .font(.system(size: 12.7, weight: .semibold))
                    .foregroundColor(.mint)
            } minimal: {
                Image(uiImage: .init(systemName: "tram.fill") ?? .add)
                    .renderingMode(.template)
                    .colorMultiply(Color("\(context.state.stationLineColorName)"))
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}
