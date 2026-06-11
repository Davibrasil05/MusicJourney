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
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Jornada", systemImage: "map.fill")
                }

            UserProfileView()
                .tabItem {
                    Label("Perfil", systemImage: "person.crop.circle.fill")
                }
        }
    }
}
