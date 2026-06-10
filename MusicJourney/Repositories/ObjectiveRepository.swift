//
//  ObjectiveViewModel.swift
//  MusicJourney
//
//  Created by Academy on 05/06/26.
//

import Foundation
import CoreData

class ObjectiveRepository: ObservableObject {
    let context = PersistenceController.shared.container.viewContext
    
    // Lista de objetivos publicados para a View observar
    @Published var objectives: [Objective] = []
    
    init() {
        fetchObjectives()
    }
    
    // MARK: - READ (Buscar)
    func fetchObjectives() {
        let request = NSFetchRequest<Objective>(entityName: "Objective")
        // Ordena pela data de criação e pelo nome
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \Objective.createdAt, ascending: false),
            NSSortDescriptor(keyPath: \Objective.name, ascending: true)
        ]
        
        do {
            objectives = try context.fetch(request)
        } catch {
            print("Erro ao buscar objetivos: \(error)")
        }
    }
    
    // MARK: - CREATE (Criar Objetivo)
    func addObjective(name: String, descriptionText: String = "") {
        let newObjective = Objective(context: context)
        newObjective.id = UUID()
        newObjective.name = name
        newObjective.descriptionText = descriptionText
        newObjective.createdAt = Date()
        newObjective.progress = 0
        newObjective.status = "active" // <- Mudou: Agora usamos String
        
        saveContext()
        fetchObjectives() // Atualiza a lista após salvar
    }
    
    // MARK: - CREATE (Criar Meta / Goal para um Objetivo)
    func addGoal(to objective: Objective, name: String, textDescription: String, category: String, difficulty: String, order: Int16) {
        let newGoal = Goal(context: context)
        newGoal.id = UUID()
        newGoal.name = name
        newGoal.textDescription = textDescription // <- Mudou: Estava description_name
        newGoal.category = category
        newGoal.difficulty = difficulty
        newGoal.order = order // <- Mudou: Substituiu o antigo 'priority'
        newGoal.isFinal = false // Default
        newGoal.xpReward = 0
        newGoal.status = "locked" // <- Mudou: Pode ser "locked", "unlocked", "completed"
        
        newGoal.objective = objective // Relacionamento seguro
        
        saveContext()
        fetchObjectives()
    }
    
    // MARK: - UPDATE (Atualizar Objetivo)
    func updateObjective(objective: Objective, newName: String) {
        objective.name = newName
        saveContext()
        fetchObjectives()
    }
    
    // MARK: - DELETE (Deletar Objetivo)
    func deleteObjective(indexSet: IndexSet) {
        guard let index = indexSet.first else { return }
        let objectiveToDelete = objectives[index]
        
        context.delete(objectiveToDelete)
        saveContext()
        fetchObjectives()
    }
    
    // MARK: - DELETE (Deletar Meta / Goal)
    func deleteGoal(goal: Goal) {
        context.delete(goal)
        saveContext()
        fetchObjectives()
    }
    
    // MARK: - TOGGLE STATUS (Agora com Strings)
    func toggleObjectiveStatus(objective: Objective) {
        if objective.status == "active" {
            objective.status = "completed"
            objective.completedAt = Date() // Salva a data que concluiu
        } else {
            objective.status = "active"
            objective.completedAt = nil // Remove a data se reabrir
        }
        
        saveContext()
        fetchObjectives()
    }
    
    func toggleGoalStatus(goal: Goal) {
        // Exemplo de fluxo: Bloqueada -> Desbloqueada -> Concluída
        if goal.status == "locked" {
            goal.status = "unlocked"
        } else if goal.status == "unlocked" {
            goal.status = "completed"
            goal.completedAt = Date()
        } else {
            goal.status = "unlocked" // Volta pra destravada se o usuário desmarcar
            goal.completedAt = nil
        }
        
        saveContext()
        fetchObjectives()
    }
    
    // MARK: - PRESETS (Objetivos pré-definidos)

    /// Retorna os presets compatíveis com o instrumento e nível do usuário
    func getPresetsForUser(instrument: String, level: String) -> [PresetObjective] {
        return PresetCatalog.presets(instrument: instrument, level: level)
    }

    /// Cria um Objective + Goals no CoreData a partir de um preset hardcoded
    func createPresetObjective(preset: PresetObjective, user: User) {
        let objective = Objective(context: context)
        objective.id = UUID()
        objective.name = preset.name
        objective.descriptionText = preset.descriptionText
        objective.createdAt = Date()
        objective.progress = 0
        objective.status = "active"
        objective.user = user

        for goalPreset in preset.goals {
            let goal = Goal(context: context)
            goal.id = UUID()
            goal.name = goalPreset.name
            goal.textDescription = goalPreset.textDescription
            goal.category = goalPreset.category
            goal.difficulty = goalPreset.difficulty
            goal.type = goalPreset.type
            goal.order = goalPreset.order
            goal.isFinal = goalPreset.isFinal
            goal.xpReward = goalPreset.xpReward
            // A primeira meta começa desbloqueada, as demais trancadas
            goal.status = goalPreset.order == 1 ? "unlocked" : "locked"
            goal.objective = objective
        }

        saveContext()
        fetchObjectives()
    }

    // MARK: - Save Helper
    private func saveContext() {
        do {
            try context.save()
        } catch {
            print("Erro ao salvar no Core Data: \(error)")
        }
    }
}
