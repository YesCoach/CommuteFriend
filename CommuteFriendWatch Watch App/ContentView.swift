//
//  ContentView.swift
//  CommuteFriendWatch Watch App
//
//  Created by 박태현 on 11/10/24.
//

import SwiftUI

struct ContentView: View {

//    @Environment(StationArrivalResponse.self) var modelData
    var body: some View {
        VStack {
            HStack {
                Text("출퇴근메이트")
                    .font(.headline)
                    .foregroundStyle(.tint)
                Spacer()
            }
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
