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
        NavigationStack {
            Spacer()
            List {
                Section {
                    NavigationLink {

                    } label: {
                        HStack {
                            Image(systemName: "tram.fill")
                            Text("지하철도착정보")
                        }
                    }
                    NavigationLink {

                    } label: {
                        HStack {
                            Image(systemName: "bus.fill")
                            Text("버스도착정보")
                        }
                    }
                } header: {
                    Text("즐겨찾기")
                        .font(.headline)
                        .padding(.leading, -15)
                        .padding(.bottom, 4)
                }
            }
            .navigationTitle("출퇴근메이트")
            .toolbarForegroundStyle(.purple, for: .navigationBar)
        }
    }
}

#Preview {
    ContentView()
}
