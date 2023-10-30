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
            VStack(spacing: 10) {
                Spacer(minLength: 5)
                HStack(spacing: 5) {
                    Spacer().frame(width: 10)
                    Button("\(context.state.stationLine)") { }
                        .buttonStyle(
                            InsetRoundButton(
                                labelColor: .white,
                                backgroundColor: .init(context.state.stationLineColorName)
                            )
                        )
                    Text("\(context.state.stationName)")
                        .foregroundColor(.white)
                        .font(.system(size: 22.0, weight: .semibold))
                        .lineLimit(1)
                    Spacer(minLength: 2.0)
                    Text("\(context.state.nextStation) 방면")
                        .foregroundColor(.white)
                    Spacer().frame(width: 10)
                }
                HStack {
                    Spacer()
                    Text("도착까지 ")
                        .font(.system(size: 22.0, weight: .semibold))
                        .foregroundColor(.white)
                    Text(timerInterval: context.state.timer, countsDown: true)
                        .multilineTextAlignment(.center)
                        .monospacedDigit()
                        .font(.system(size: 30, weight: .semibold))
                        .foregroundColor(Color(uiColor: .systemGreen) .opacity(0.8))
                        .frame(width: 100)
                    Spacer()
                }
                Spacer(minLength: 5)
            }
            .background(.black.opacity(0.6))
        } else {
            VStack(spacing: 10) {
                Spacer(minLength: 5)
                HStack(spacing: 5) {
                    Spacer().frame(width: 10)
                    Button("\(context.state.stationLine)") { }
                        .buttonStyle(
                            InsetRoundButton(
                                labelColor: .white,
                                backgroundColor: .init(context.state.stationLineColorName)
                            )
                        )
                    Text("\(context.state.stationName)")
                        .foregroundColor(.white)
                        .font(.system(size: 22.0, weight: .semibold))
                        .lineLimit(1)
                    Spacer(minLength: 2.0)
                    Text("\(context.state.nextStation) 방면")
                        .foregroundColor(.white)
                    Spacer().frame(width: 10)
                }
                HStack {
                    Spacer()
                    Text("도착까지 ")
                        .font(.system(size: 22.0, weight: .semibold))
                        .foregroundColor(.white)
                    Text(timerInterval: context.state.timer, countsDown: true)
                        .multilineTextAlignment(.center)
                        .monospacedDigit()
                        .font(.system(size: 30, weight: .semibold))
                        .foregroundColor(Color(uiColor: .systemGreen) .opacity(0.8))
                        .frame(width: 100)
                    Spacer()
                }
                Spacer(minLength: 5)
            }
            .background(.black.opacity(0.4))
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
            .background(Capsule().fill(backgroundColor)) // <-
    }
}
