//
//  AnnotationRepository.swift
//  MusicJourney
//
//  Created by academy on 10/06/26.
//

import Foundation
import CoreData

class AnnotationRepository {
    
    let context = PersistenceController.shared.container.viewContext
    
    func createAnnotation(goal: Goal, session: Session?) -> Annotation{
        
        let newAnnotation = Annotation(context: context)
        
        newAnnotation.id = UUID()
        newAnnotation.text = ""
        newAnnotation.goal = goal
        newAnnotation.session = session
        newAnnotation.createdAt = Date()
        
        saveContext()
        return newAnnotation
        
    }
    
    func updateAnnotation(_ annotation: Annotation, newText: String) {
        annotation.text = newText
        saveContext()
    }
    
    func fetchAnnotations(goal: Goal) -> [Annotation] {
        let request = NSFetchRequest<Annotation>(entityName: "Annotation")
        request.predicate = NSPredicate(format: "goal == %@", goal)
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \Annotation.createdAt, ascending: false)
        ]
        
        do {
            return try context.fetch(request)
        } catch {
            print("Erro ao buscar anotações: \(error)")
            return []
        }
    }
    
    func deleteAnnotation(_ annotation: Annotation) {
        context.delete(annotation)
        saveContext()
    }
    
    private func saveContext() {
        do {
            try context.save()
        } catch {
            print("Erro ao salvar anotação: \(error)")
        }
    }
    
    
    
}
