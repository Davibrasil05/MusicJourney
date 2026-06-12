//
//  ContentView.swift
//  MusicJourney
//
//  Created by Academy on 05/06/26.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [],
        animation: .default)
    private var users: FetchedResults<User>

    var body: some View {
        Group {
            if users.isEmpty {
                OnboardingFormView()
            } else {
                MainTabView()
            }
        }
    }
}

struct MainTabView: View {
    @EnvironmentObject var floatingPlayerVM: FloatingPlayerViewModel

    var body: some View {
        TabView {
            NavigationView {
                HomeView()
            }
            .tabItem {
                Label("Jornada", systemImage: "map.fill")
            }

            NavigationView {
                HistoryView()
            }
            .tabItem{
                Label("Histórico", systemImage: "paper.fill")
            }

            UserProfileView()
                .tabItem {
                    Label("Perfil", systemImage: "person.crop.circle.fill")
                }
        }
        .onAppear {
            floatingPlayerVM.installOverlayWindow()
        }
    }
}
