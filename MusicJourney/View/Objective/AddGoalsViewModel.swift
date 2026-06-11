//
//  AddGoalsViewModel.swift
//  MusicJourney
//

import Foundation

// MARK: - Supporting types

enum GoalSource {
    case ai
    case manual
}

struct PendingGoalItem: Identifiable {
    let id = UUID()
    var name: String
    var textDescription: String
    var category: String      // Técnica | Repertório | Teoria
    var difficulty: String    // Fácil | Médio | Desafio
    var type: String          // practice | behavioral
    var isSelected: Bool
    var source: GoalSource
}

// MARK: - ViewModel

@MainActor
class AddGoalsViewModel: ObservableObject {

    // MARK: Published state
    @Published var aiFocusText: String = ""
    @Published var isLoadingAI: Bool = false
    @Published var aiErrorMessage: String? = nil
    @Published var pendingGoals: [PendingGoalItem] = []
    @Published var showManualSheet: Bool = false

    // MARK: Dependencies
    private let objective: Objective
    private let onFinish: () -> Void
    private let userRepository: UserRepository
    private let objectiveRepository: ObjectiveRepository
    private let geminiService: GeminiService

    private var userProfile: (instrument: String, experienceLevel: String, genresJoined: String)?

    init(
        objective: Objective,
        onFinish: @escaping () -> Void,
        userRepository: UserRepository = UserRepository(),
        objectiveRepository: ObjectiveRepository = ObjectiveRepository(),
        geminiService: GeminiService = .shared
    ) {
        self.objective = objective
        self.onFinish = onFinish
        self.userRepository = userRepository
        self.objectiveRepository = objectiveRepository
        self.geminiService = geminiService

        loadUserProfile()
    }

    // MARK: - Helpers

    var hasSelectedGoals: Bool {
        pendingGoals.contains { $0.isSelected }
    }

    private func loadUserProfile() {
        userRepository.fetchUser()
        if let user = userRepository.currentUser {
            userProfile = userRepository.aiProfileSnapshot(from: user)
        }
    }

    // MARK: - Actions

    func generateWithAI() {
        guard !isLoadingAI else { return }

        guard let profile = userProfile else {
            aiErrorMessage = "Complete o onboarding antes de gerar metas."
            return
        }

        isLoadingAI = true
        aiErrorMessage = nil

        let objectiveName = objective.name ?? ""
        let focus = aiFocusText.trimmingCharacters(in: .whitespacesAndNewlines)
        let prompt = focus.isEmpty ? objectiveName : "\(objectiveName) — \(focus)"

        Task {
            do {
                let dtos = try await geminiService.generateGoals(
                    instrument: profile.instrument,
                    level: profile.experienceLevel,
                    genres: profile.genresJoined,
                    objective: prompt
                )

                if dtos.isEmpty {
                    aiErrorMessage = "Só consigo ajudar na sua jornada musical. Tente focar no seu instrumento!"
                } else {
                    let newItems = dtos.map { dto in
                        PendingGoalItem(
                            name: dto.name,
                            textDescription: dto.textDescription,
                            category: dto.category,
                            difficulty: dto.difficulty,
                            type: dto.type,
                            isSelected: false,
                            source: .ai
                        )
                    }
                    pendingGoals.append(contentsOf: newItems)
                }
            } catch let urlError as URLError {
                switch urlError.code {
                case .notConnectedToInternet, .networkConnectionLost, .timedOut:
                    aiErrorMessage = "Sem conexão. Verifique sua internet e tente novamente."
                default:
                    aiErrorMessage = "Não foi possível contatar a IA. Tente novamente."
                }
            } catch {
                let msg = error.localizedDescription.lowercased()
                if msg.contains("401") || msg.contains("unauthorized") || msg.contains("authentication") {
                    aiErrorMessage = "Erro de autenticação da IA. Verifique sua chave em Secrets.swift."
                } else if msg.contains("decode") || msg.contains("json") || msg.contains("invalid") {
                    aiErrorMessage = "A IA retornou uma resposta inválida. Tente novamente."
                } else {
                    aiErrorMessage = "Não consegui gerar metas para esse objetivo. Tente focar em algo musical."
                }
            }

            isLoadingAI = false
        }
    }

    func toggleSelection(id: UUID) {
        if let index = pendingGoals.firstIndex(where: { $0.id == id }) {
            pendingGoals[index].isSelected.toggle()
        }
    }

    func addManualGoal(name: String, description: String, category: String, difficulty: String) {
        let item = PendingGoalItem(
            name: name,
            textDescription: description,
            category: category,
            difficulty: difficulty,
            type: "practice",
            isSelected: true,
            source: .manual
        )
        pendingGoals.append(item)
    }

    func saveGoals() {
        let selected = pendingGoals.filter { $0.isSelected }
        guard !selected.isEmpty else { return }

        let items = selected.map { item in
            (name: item.name,
             textDescription: item.textDescription,
             category: item.category,
             difficulty: item.difficulty,
             type: item.type)
        }
        objectiveRepository.addGoals(to: objective, items: items)
        onFinish()
    }
}
