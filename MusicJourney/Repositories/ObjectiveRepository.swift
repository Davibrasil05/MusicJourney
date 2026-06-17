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
    @discardableResult
    func addObjective(name: String, descriptionText: String = "", user: User? = nil, reminderTime: Date? = nil, isDailyReminder: Bool = false) -> Objective {
        let newObjective = Objective(context: context)
        newObjective.id = UUID()
        newObjective.name = name
        newObjective.descriptionText = descriptionText
        newObjective.createdAt = Date()
        newObjective.progress = 0
        newObjective.status = "active"
        newObjective.reminderTime = reminderTime
        newObjective.isDailyReminder = isDailyReminder
        newObjective.user = user

        saveContext()
        fetchObjectives()

        return newObjective
    }

    // MARK: - CREATE (Criar Meta / Goal para um Objetivo)
    @discardableResult
    func addGoal(to objective: Objective, name: String, textDescription: String, category: String, difficulty: String, type: String = "practice", order: Int16) -> Goal {
        let newGoal = Goal(context: context)
        newGoal.id = UUID()
        newGoal.name = name
        newGoal.textDescription = textDescription
        newGoal.category = category
        newGoal.difficulty = difficulty
        newGoal.type = type
        newGoal.order = order
        newGoal.isFinal = false
        newGoal.xpReward = 0
        // First goal in the trail starts unlocked; the rest stay locked
        newGoal.status = order == 1 ? "unlocked" : "locked"
        newGoal.objective = objective

        saveContext()
        fetchObjectives()
        return newGoal
    }

    // MARK: - CREATE (batch from AI / manual pending list)
    func addGoals(to objective: Objective, items: [(name: String, textDescription: String, category: String, difficulty: String, type: String)]) {
        for (index, item) in items.enumerated() {
            addGoal(
                to: objective,
                name: item.name,
                textDescription: item.textDescription,
                category: item.category,
                difficulty: item.difficulty,
                type: item.type,
                order: Int16(index + 1)
            )
        }
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
    
    // MARK: - TOGGLE STATUS
    func toggleObjectiveStatus(objective: Objective) {
        if objective.status == "active" {
            objective.status = "completed"
            objective.completedAt = Date()
        } else {
            objective.status = "active"
            objective.completedAt = nil
        }
        
        saveContext()
        fetchObjectives()
    }
    
    func toggleGoalStatus(goal: Goal) {
        if goal.status == "locked" {
            goal.status = "unlocked"
        } else if goal.status == "unlocked" {
            goal.status = "completed"
            goal.completedAt = Date()
        } else {
            goal.status = "unlocked"
            goal.completedAt = nil
        }
        
        saveContext()
        fetchObjectives()
    }
    
    // MARK: - PRESETS (Objetivos pré-definidos)
    func getPresetsForUser(instrument: String, level: String) -> [PresetObjective] {
        return PresetCatalog.presets(instrument: instrument, level: level)
    }

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
