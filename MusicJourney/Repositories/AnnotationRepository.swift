//
//  AnnotationRepository.swift
//  MusicJourney
//
//

import Foundation
import CoreData

class AnnotationRepository: ObservableObject {
    let context = PersistenceController.shared.container.viewContext
    
    // Lista de anotações que vai aparecer na tela de registros
    @Published var annotations: [Annotation] = []
    
    // MARK: - CREATE
    func createAnnotation(title: String, text: String, goal: Goal?, session: Session?) {
        let newNote = Annotation(context: context)
        newNote.id = UUID()
        newNote.title = title // Novo campo adicionado!
        newNote.text = text
        newNote.createdAt = Date()
        
        if let goal = goal {
            newNote.goal = goal
        }
        if let session = session {
            newNote.session = session
        }
        
        saveContext()
        
        // Atualiza a lista logo após criar
        if let goal = goal {
            fetchAnnotations(for: goal)
        }
    }
    
    // MARK: - READ
    func fetchAnnotations(for goal: Goal) {
        let request = NSFetchRequest<Annotation>(entityName: "Annotation")
        // Pega só as notas que pertencem a esta meta (Goal)
        request.predicate = NSPredicate(format: "goal == %@", goal)
        // Mais recentes primeiro
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Annotation.createdAt, ascending: false)]
        
        do {
            annotations = try context.fetch(request)
        } catch {
            print("Erro ao buscar anotações: \(error)")
        }
    }
    
    // MARK: - UPDATE (Usado no "Editar nome")
    func updateAnnotation(annotation: Annotation, newTitle: String?, newText: String?) {
        if let title = newTitle {
            annotation.title = title
        }
        if let text = newText {
            annotation.text = text
        }
        
        saveContext()
        if let goal = annotation.goal {
            fetchAnnotations(for: goal)
        }
    }
    
    // MARK: - DELETE
    func deleteAnnotation(_ annotation: Annotation) {
        let goal = annotation.goal
        context.delete(annotation)
        saveContext()
        
        if let goal = goal {
            fetchAnnotations(for: goal)
        }
    }
    
    // MARK: - Save Helper
    private func saveContext() {
        do {
            try context.save()
        } catch {
            print("Erro ao salvar anotação no Core Data: \(error)")
        }
    }
}
