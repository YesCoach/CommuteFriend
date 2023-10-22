//
//  ArrivalWidgetLiveActivityView.swift
//  CommuteFriend
//
//  Created by 박태현 on 2023/10/21.
//

import SwiftUI
import ActivityKit
import WidgetKit

struct ArrivalWidgetLiveActivityView: View {

    let context: ActivityViewContext<ArrivalWidgetAttributes>
    @Environment(\.isLuminanceReduced) var isLuminanceReduced

    var body: some View {
        if isLuminanceReduced {
            VStack(spacing: 3) {
                Spacer(minLength: 14)
                HStack(spacing: 5) {
                    Text("\(context.attributes.stationLine)")
                        .foregroundColor(Color(context.attributes.stationLineColorName))
                    Text("\(context.attributes.stationName)")
                        .foregroundColor(.white.opacity(0.5))
                    Spacer()
                    Text("\(context.attributes.nextStation)")
                        .foregroundColor(.gray.opacity(0.5))
                }
                Text(context.state.timer, style: .timer)
                    .multilineTextAlignment(.center)
                    .monospacedDigit()
                    .font(.system(size: 44, weight: .semibold))
                    .foregroundColor(Color(uiColor: .systemMint) .opacity(0.5))
            }
            .background(.black.opacity(0.6))
        } else {
            VStack(spacing: -3) {
                Spacer(minLength: 14)
                HStack(spacing: 5) {
                    Text("\(context.attributes.stationLine)")
                        .foregroundColor(Color(context.attributes.stationLineColorName).opacity(0.6))
                    Text("\(context.attributes.stationName)")
                        .foregroundColor(.white.opacity(0.6))
                    Spacer()
                    Text("\(context.attributes.nextStation)")
                        .foregroundColor(.gray.opacity(0.6))
                }
                Text(context.state.timer, style: .timer)
                    .multilineTextAlignment(.center)
                    .monospacedDigit()
                    .font(.system(size: 48, weight: .semibold))
                    .foregroundColor(Color(uiColor: .systemGreen) .opacity(0.8))
                Spacer()
            }
            .background(.black.opacity(0.6))
        }
    }
}

