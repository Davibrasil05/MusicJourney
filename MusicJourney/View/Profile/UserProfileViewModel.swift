//
//  UserProfileViewModel.swift
//  MusicJourney
//
//  Created by Academy on 15/06/26.
//

import Foundation

class UserProfileViewModel: ObservableObject {
    private let userRepository = UserRepository()
    
    @Published var selectedInstrument: MusicInstrument = .violao
    @Published var selectedLevel: MusicLevel = .iniciante
    @Published var selectedSchedule: PracticeSchedule = .noite
    @Published var selectedGenres: Set<MusicGenre> = []
    
    var currentUser: User? {
        userRepository.currentUser
    }
    
    var genresSummary: String {
        selectedGenres.isEmpty
            ? "Nenhum"
            : selectedGenres.map(\.rawValue).sorted().joined(separator: ", ")
    }
    
    private var hasLoadedProfile = false
    
    func loadProfile(from user: User) {
        guard !hasLoadedProfile else { return }
        
        selectedInstrument = MusicInstrument(rawValue: user.instrument ?? "") ?? .violao
        selectedLevel = MusicLevel(rawValue: user.experienceLevel ?? "") ?? .iniciante
        selectedSchedule = PracticeSchedule(rawValue: user.practiceSchedule ?? "") ?? .noite
        let saved = user.genres as? [String] ?? []
        selectedGenres = Set(saved.compactMap { MusicGenre(rawValue: $0) })
        
        hasLoadedProfile = true
    }
    
    func saveProfile(to user: User) {
        user.instrument = selectedInstrument.rawValue
        user.experienceLevel = selectedLevel.rawValue
        user.level = selectedLevel.levelValue
        user.practiceSchedule = selectedSchedule.rawValue
        user.genres = selectedGenres.map(\.rawValue) as NSArray
        userRepository.save()

        Task {
            await PracticeNotificationService.shared.syncReminder(for: selectedSchedule)
        }
    }
}

