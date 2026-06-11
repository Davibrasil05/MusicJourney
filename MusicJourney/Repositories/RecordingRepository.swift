//
//  RecordingRepository.swift
//  MusicJourney
//
//  Created by academy on 11/06/26.
//

import Foundation
import CoreData

class RecordingRepository: ObservableObject {

    let context = PersistenceController.shared.container.viewContext
    
    // Variável publicada para as listas observarem
    @Published var recordings: [Recording] = []

    func createRecording(title: String, fileURL: String, duration: Double, goal: Goal, session: Session?) -> Recording {
        let newRecording = Recording(context: context)
        newRecording.id = UUID()
        newRecording.title = title // Novo campo obrigatório!
        newRecording.fileURL = fileURL
        newRecording.duration = duration
        newRecording.createdAt = Date()
        newRecording.lastPlayedAt = nil
        newRecording.goal = goal
        newRecording.session = session

        saveContext()
        fetchRecordings(goal: goal)
        return newRecording
    }

    func fetchRecordings(goal: Goal) {
        let request = NSFetchRequest<Recording>(entityName: "Recording")
        request.predicate = NSPredicate(format: "goal == %@", goal)
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Recording.createdAt, ascending: false)]

        do {
            recordings = try context.fetch(request)
        } catch {
            print("Erro ao buscar gravações da meta: \(error)")
        }
    }
    
    // NOVO: Função para o usuário editar o nome na aba de registros
    func updateRecordingTitle(recording: Recording, newTitle: String) {
        recording.title = newTitle
        saveContext()
        if let goal = recording.goal {
            fetchRecordings(goal: goal)
        }
    }

    func updateLastPlayed(recording: Recording) {
        recording.lastPlayedAt = Date()
        saveContext()
    }

    func deleteRecording(_ recording: Recording) {
        // 1. Apaga o arquivo físico do dispositivo
        if let filePath = recording.fileURL, let url = URL(string: filePath) {
            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: url.path) {
                do {
                    try fileManager.removeItem(at: url)
                } catch {
                    print("Erro ao apagar arquivo de áudio: \(error)")
                }
            }
        }

        // 2. Apaga do Banco de Dados
        let goal = recording.goal
        context.delete(recording)
        saveContext()
        
        // 3. Atualiza a lista na UI
        if let goal = goal {
            fetchRecordings(goal: goal)
        }
    }

    private func saveContext() {
        do {
            try context.save()
        } catch {
            print("Erro ao salvar gravação: \(error)")
        }
    }
}
