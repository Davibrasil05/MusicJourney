//
//  MusicJourneyApp.swift
//  MusicJourney
//
//  Created by Academy on 05/06/26.
//

import SwiftUI

@main
struct MusicJourneyApp: App {
    let persistenceController = PersistenceController.shared
    @StateObject private var floatingPlayerVM = FloatingPlayerViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(floatingPlayerVM)
        }
    }
}
