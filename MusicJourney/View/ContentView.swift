//
//  ContentView.swift
//  MusicJourney
//
//  Created by Academy on 05/06/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            JourneyView()
                .tabItem {
                    Label("Jornada", systemImage: "map")
                }
            
            HistoryView()
                .tabItem {
                    Label("Histórico", systemImage: "clock.fill")
                }
        }
    }
}
