//
//  CreateObjectiveViewModel.swift
//  MusicJourney
//

import Foundation

class CreateObjectiveViewModel: ObservableObject {
    @Published var title: String = ""

    var canContinue: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    private let objectiveRepository: ObjectiveRepository
    private let userRepository: UserRepository

    init(
        objectiveRepository: ObjectiveRepository = ObjectiveRepository(),
        userRepository: UserRepository = UserRepository()
    ) {
        self.objectiveRepository = objectiveRepository
        self.userRepository = userRepository
    }

    /// Persists the objective in Core Data and returns it.
    /// Returns nil only if title is empty (guarded by `canContinue`).
    @discardableResult
    func createObjective() -> Objective? {
        let trimmed = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return nil }
        let objective = objectiveRepository.addObjective(
            name: trimmed,
            user: userRepository.currentUser
        )
        return objective
    }
}
