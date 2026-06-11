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
        container = Self.makeContainer(inMemory: inMemory, allowStoreReset: true)
    }

    // MARK: - Store loading

    private static func makeContainer(inMemory: Bool, allowStoreReset: Bool) -> NSPersistentContainer {
        let container = NSPersistentContainer(name: "MusicJourney")
        configureStoreDescriptions(for: container, inMemory: inMemory)

        var loadError: NSError?
        container.loadPersistentStores { _, error in
            loadError = error as NSError?
        }

        if let error = loadError {
            #if DEBUG
            if allowStoreReset, !inMemory,
               let storeURL = container.persistentStoreDescriptions.first?.url,
               destroyPersistentStore(at: storeURL) {
                print("⚠️ Core Data: banco incompatível removido. Um banco novo será criado.")
                return makeContainer(inMemory: inMemory, allowStoreReset: false)
            }
            #endif
            fatalError("Unresolved error \(error), \(error.userInfo)")
        }

        return container
    }

    private static func configureStoreDescriptions(for container: NSPersistentContainer, inMemory: Bool) {
        guard let description = container.persistentStoreDescriptions.first else { return }

        if inMemory {
            description.url = URL(fileURLWithPath: "/dev/null")
        }

        description.setOption(true as NSNumber, forKey: NSMigratePersistentStoresAutomaticallyOption)
        description.setOption(true as NSNumber, forKey: NSInferMappingModelAutomaticallyOption)
        container.viewContext.automaticallyMergesChangesFromParent = true
    }

    /// Remove sqlite + arquivos auxiliares (-shm, -wal) após falha de migração.
    private static func destroyPersistentStore(at storeURL: URL) -> Bool {
        let fileManager = FileManager.default
        let relatedURLs = [
            storeURL,
            URL(fileURLWithPath: storeURL.path + "-shm"),
            URL(fileURLWithPath: storeURL.path + "-wal")
        ]

        var removedAny = false
        for url in relatedURLs where fileManager.fileExists(atPath: url.path) {
            try? fileManager.removeItem(at: url)
            removedAny = true
        }
        return removedAny
    }
}
