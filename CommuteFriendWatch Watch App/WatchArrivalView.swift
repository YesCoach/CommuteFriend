//
//  WatchArrivalView.swift
//  CommuteFriend
//
//  Created by 박태현 on 11/17/24.
//

import SwiftUI

struct WatchArrivalView: View {

    var body: some View {
        TabView {
            ForEach(0..<3, id: \.self) { item in
                WatchArrivalContentView()
            }
        }
        .tabViewStyle(.page)
        .indexViewStyle(.page)
        .navigationTitle("출퇴근메이트")
        .toolbarForegroundStyle(.purple, for: .navigationBar)
    }

}

struct WatchArrivalContentView: View {

    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                Button("2") { }
                    .buttonStyle(
                        InsetRoundButton(
                            labelColor: .white,
                            backgroundColor: .green
                        )
                    )
                Spacer().frame(width: 10)
                Text("홍대입구")
                    .foregroundStyle(.white)
                    .font(.title3)
                    .lineLimit(1)
                Spacer()
            }
            HStack {
                Spacer()
                Text("신촌 방면")
                    .foregroundStyle(.white)
                    .font(.body)
            }
            Spacer()
            HStack {
                Text("이번열차")
                Text(timerInterval: Date()...Date().addingTimeInterval(120), countsDown: true)
                    .multilineTextAlignment(.center)
                    .monospacedDigit()
                    .font(.body)
                    .foregroundStyle(.white)
            }
            HStack {
                Text("다음열차")
                Text(timerInterval: Date()...Date().addingTimeInterval(240), countsDown: true)
                    .multilineTextAlignment(.center)
                    .monospacedDigit()
                    .font(.body)
                    .foregroundStyle(.white)
            }
            Spacer()
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
            .fontWeight(.semibold)
            .background(Capsule().fill(backgroundColor))
    }
}


#Preview {
    ContentView()
}
