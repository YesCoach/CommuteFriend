//
//  ArrivalWidgetLiveActivityView.swift
//  CommuteFriend
//
//  Created by 박태현 on 2023/10/21.
//

import ActivityKit
import SwiftUI
import WidgetKit

struct ArrivalWidgetLiveActivityView: View {

    let context: ActivityViewContext<ArrivalWidgetAttributes>
    @Environment(\.isLuminanceReduced) var isLuminanceReduced
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        if isLuminanceReduced {
            VStack(spacing: 5) {
                Spacer(minLength: 5)
                HStack(alignment: .bottom) {
                    Spacer().frame(width: 10)
                    Button("\(context.state.stationLine)") { }
                        .buttonStyle(
                            InsetRoundButton(
                                labelColor: .white,
                                backgroundColor: .init(context.state.stationLineColorName)
                            )
                        )
                    Spacer().frame(width: 10)
                    Text("\(context.state.stationName)")
                        .foregroundStyle(.primary)
                        .font(.system(size: 22.0, weight: .semibold))
                        .lineLimit(1)
                    Spacer(minLength: 2.0)
                    Text("\(context.state.nextStation) 방면")
                        .foregroundStyle(.primary)
                        .font(.system(size: 16.0, weight: .semibold))
                    Spacer().frame(width: 10)
                }
                Text(timerInterval: context.state.timer, countsDown: true)
                    .multilineTextAlignment(.center)
                    .monospacedDigit()
                    .font(.system(size: 44, weight: .semibold))
                    .foregroundStyle(.activityText)
                Text("도착까지")
                    .font(.system(size: 14.0, weight: .semibold))
                    .foregroundStyle(.primary)
                Spacer(minLength: 5)
            }
            .activityBackgroundTint(
                colorScheme == .dark ? .init(uiColor: .black).opacity(0.5) : .init(uiColor: .white).opacity(0.5)
            )
        } else {
            VStack(spacing: 5) {
                Spacer(minLength: 5)
                HStack(alignment: .bottom) {
                    Spacer().frame(width: 10)
                    Button("\(context.state.stationLine)") { }
                        .buttonStyle(
                            InsetRoundButton(
                                labelColor: .white,
                                backgroundColor: .init(context.state.stationLineColorName)
                            )
                        )
                    Spacer().frame(width: 10)
                    Text("\(context.state.stationName)")
                        .foregroundStyle(.activityText)
                        .font(.system(size: 22.0, weight: .semibold))
                        .lineLimit(1)
                    Spacer(minLength: 2.0)
                    Text("\(context.state.nextStation) 방면")
                        .foregroundStyle(.activityText)
                        .font(.system(size: 16.0, weight: .semibold))
                    Spacer().frame(width: 10)
                }
                Text(timerInterval: context.state.timer, countsDown: true)
                    .multilineTextAlignment(.center)
                    .monospacedDigit()
                    .font(.system(size: 44, weight: .semibold))
                    .foregroundStyle(.activityText)
                Text("도착까지")
                    .font(.system(size: 14.0, weight: .semibold))
                    .foregroundStyle(.activityText)
                Spacer(minLength: 5)
            }
            .activityBackgroundTint(Color.background)
        }
    }
}

struct InsetRoundButton: ButtonStyle {
    var labelColor = Color.white
    var backgroundColor = Color.blue

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(labelColor)
            .padding(.init(top: 4, leading: 8, bottom: 4, trailing: 8))
            .fontWeight(.bold)
            .background(Capsule().fill(backgroundColor))
    }
}
