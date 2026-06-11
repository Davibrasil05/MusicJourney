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
    @Published var showAIErrorAlert: Bool = false
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

    private func presentAIError(_ message: String) {
        aiErrorMessage = message
        showAIErrorAlert = true
    }

    /// Fast local guard for obviously non-musical focus text before calling the API.
    private func isOffTopicFocus(_ focus: String) -> Bool {
        let normalized = focus
            .folding(options: .diacriticInsensitive, locale: .current)
            .lowercased()

        let blockedPhrases = [
            "treino de peito", "treino de perna", "treino de costas", "treino de braco",
            "treino de ombro", "treino de abdomen", "treino de gluteo",
            "academia", "musculacao", "supino", "agachamento", "leg press",
            "corrida", "emagrecer", "dieta", "financas", "investimento",
            "programacao", "codigo", "matematica", "historia", "geografia"
        ]

        return blockedPhrases.contains { normalized.contains($0) }
    }

    // MARK: - Actions

    func generateWithAI() {
        guard !isLoadingAI else { return }

        guard let profile = userProfile else {
            presentAIError("Complete o onboarding antes de gerar metas.")
            return
        }

        let objectiveTitle = objective.name ?? ""
        let focus = aiFocusText.trimmingCharacters(in: .whitespacesAndNewlines)

        if !focus.isEmpty && isOffTopicFocus(focus) {
            presentAIError("Só consigo ajudar na sua jornada musical. Tente focar no seu instrumento!")
            return
        }

        isLoadingAI = true
        aiErrorMessage = nil

        Task {
            do {
                let dtos = try await geminiService.generateGoals(
                    instrument: profile.instrument,
                    level: profile.experienceLevel,
                    genres: profile.genresJoined,
                    objectiveTitle: objectiveTitle,
                    focus: focus
                )

                if dtos.isEmpty {
                    let message = focus.isEmpty
                        ? "Só consigo ajudar na sua jornada musical. Tente focar no seu instrumento!"
                        : "Só consigo ajudar na sua jornada musical. O foco informado não parece estar relacionado à música."
                    presentAIError(message)
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
                    presentAIError("Sem conexão. Verifique sua internet e tente novamente.")
                default:
                    presentAIError("Não foi possível contatar a IA. Tente novamente.")
                }
            } catch {
                let msg = error.localizedDescription.lowercased()
                if msg.contains("401") || msg.contains("unauthorized") || msg.contains("authentication") {
                    presentAIError("Erro de autenticação da IA. Verifique sua chave em Secrets.swift.")
                } else if msg.contains("decode") || msg.contains("json") || msg.contains("invalid") {
                    presentAIError("A IA retornou uma resposta inválida. Tente novamente.")
                } else {
                    presentAIError("Não consegui gerar metas para esse objetivo. Tente focar em algo musical.")
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
