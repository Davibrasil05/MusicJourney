//
//  ObjectiveViewModel.swift
//  MusicJourney
//
//  Created by Academy on 05/06/26.
//

import Foundation
import CoreData

class ObjectiveViewModel: ObservableObject {
    let context = PersistenceController.shared.container.viewContext
    
    // Lista de objetivos publicados para a View observar
    @Published var objectives: [Objective] = []
    
    init() {
        fetchObjectives()
    }
    
    // MARK: - READ (Buscar)
    func fetchObjectives() {
        let request = NSFetchRequest<Objective>(entityName: "Objective")
        // Opcional: Adicionar um sortDescriptor para ordenar alfabeticamente
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Objective.name, ascending: true)]
        
        do {
            objectives = try context.fetch(request)
        } catch {
            print("Erro ao buscar objetivos: \(error)")
        }
    }
    
    // MARK: - CREATE (Criar Objetivo)
    func addObjective(name: String) {
        let newObjective = Objective(context: context)
        newObjective.id = UUID()
        newObjective.name = name
        newObjective.status = false
        
        saveContext()
        fetchObjectives() // Atualiza a lista após salvar
    }
    
    // MARK: - CREATE (Criar Meta / Goal para um Objetivo)
    // MARK: - CREATE (Criar Meta / Goal para um Objetivo)
    func addGoal(to objective: Objective, name: String, descriptionName: String, category: String, difficulty: String, priority: Int16, time: Date) {
        let newGoal = Goal(context: context)
        newGoal.id = UUID()
        newGoal.name = name
        newGoal.description_name = descriptionName
        newGoal.category = category
        newGoal.difficulty = difficulty
        newGoal.priority = priority
        newGoal.time = time
        newGoal.status = false
        
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
    
    // MARK: - TOGGLE STATUS
    func toggleObjectiveStatus(objective: Objective) {
        objective.status.toggle()
        saveContext()
        fetchObjectives()
    }
    
    func toggleGoalStatus(goal: Goal) {
        goal.status.toggle()
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
