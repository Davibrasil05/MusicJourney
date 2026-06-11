//
//  RecordingRepository.swift
//  MusicJourney
//
//  Created by academy on 11/06/26.
//

import Foundation
import CoreData

class RecordingRepository {

    let context = PersistenceController.shared.container.viewContext

    func createRecording(fileURL: String, duration: Double, goal: Goal, session: Session?) -> Recording {
        let newRecording = Recording(context: context)
        newRecording.id = UUID()
        newRecording.fileURL = fileURL
        newRecording.duration = duration
        newRecording.createdAt = Date()
        newRecording.lastPlayedAt = nil
        newRecording.goal = goal
        newRecording.session = session

        saveContext()
        return newRecording
    }

    //Busca gravacoes associadas a uma meta
    func fetchRecordings(goal: Goal) -> [Recording] {
        let request = NSFetchRequest<Recording>(entityName: "Recording")
        request.predicate = NSPredicate(format: "goal == %@", goal)
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \Recording.createdAt, ascending: false)
        ]

        do {
            return try context.fetch(request)
        } catch {
            print("Erro ao buscar gravações da meta: \(error)")
            return []
        }
    }


    //Busca todas as gravacoes associadas ao objetivo
    func fetchRecordings(objective: Objective) -> [Recording] {
        let request = NSFetchRequest<Recording>(entityName: "Recording")
        request.predicate = NSPredicate(format: "goal.objective == %@", objective)
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \Recording.createdAt, ascending: true)
        ]

        do {
            return try context.fetch(request)
        } catch {
            print("Erro ao buscar gravações do objetivo: \(error)")
            return []
        }
    }

    func updateLastPlayed(recording: Recording) {
        recording.lastPlayedAt = Date()
        saveContext()
    }

    func deleteRecording(_ recording: Recording) {
        // 1. Apaga o arquivo físico do dispositivo
        if let filePath = recording.fileURL {
            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: filePath) {
                do {
                    try fileManager.removeItem(atPath: filePath)
                } catch {
                    print("Erro ao apagar arquivo de áudio: \(error)")
                }
            }
        }

        context.delete(recording)
        saveContext()
    }

    private func saveContext() {
        do {
            try context.save()
        } catch {
            print("Erro ao salvar gravação: \(error)")
        }
    }
}
