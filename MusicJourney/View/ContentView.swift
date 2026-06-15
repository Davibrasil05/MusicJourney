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

    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithDefaultBackground()
        // Opcional: Se quiser uma cor sólida, pode descomentar a linha abaixo:
        appearance.backgroundColor = UIColor(named: "cardCream")
        
        UITabBar.appearance().standardAppearance = appearance
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }

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
                Label("Histórico", systemImage: "clock.fill")
            }

            UserProfileView()
                .tabItem {
                    Label("Perfil", systemImage: "person.crop.circle.fill")
                }
        }
        .onAppear {
            floatingPlayerVM.installOverlayWindow()
            Task {
                let userRepo = UserRepository()
                if let user = userRepo.currentUser {
                    await PracticeNotificationService.shared.syncReminder(forUser: user)
                }
            }
        }
    }
}
