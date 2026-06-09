//
//  Persistence.swift
//  MusicJourney
//
//  Created by Academy on 05/06/26.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
        // MARK: - Usuário Preview
        let user = User(context: viewContext)
        user.id = UUID()
        user.name = "Preview User"
        user.instrument = "Violão"
        user.experienceLevel = "Intermediário" // Atualizado
        user.practiceSchedule = "Noite" // Novo
        user.genres = ["Rock", "MPB"] as NSObject // Novo
        user.level = 2
        user.xp = 50 // Atualizado
        user.streak = 5
        
        // MARK: - Objetivo Preview (Bônus para o SwiftUI Canvas ficar lindo)
        let objective = Objective(context: viewContext)
        objective.id = UUID()
        objective.name = "Aprender Stairway to Heaven"
        objective.descriptionText = "Tocar a música inteira sem errar o solo"
        objective.createdAt = Date()
        objective.status = "active"
        objective.progress = 0
        objective.user = user // Relacionamento com o usuário
        
        // MARK: - Meta (Goal) Preview
        let goal = Goal(context: viewContext)
        goal.id = UUID()
        goal.name = "Tirar a introdução dedilhada"
        goal.textDescription = "Praticar lentamente do compasso 1 ao 16"
        goal.category = "Técnica"
        goal.difficulty = "Média"
        goal.order = 1
        goal.status = "unlocked"
        goal.xpReward = 15
        goal.isFinal = false
        goal.objective = objective // Relacionamento com o objetivo
        
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "MusicJourney")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // fatalError() causa o encerramento do app em caso de crash.
                // Substitua em um app de produção se necessário.
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
}
