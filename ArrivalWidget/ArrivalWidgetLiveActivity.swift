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
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var timer: ClosedRange<Date>
    }

    // Fixed non-changing properties about your activity go here!
    // var stationTarget: StationArrivalResponse
    var stationName: String
    var stationLine: String
    var stationLineColorName: String
    var nextStation: String
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
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T")
            } minimal: {
                Text("Min")
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}
