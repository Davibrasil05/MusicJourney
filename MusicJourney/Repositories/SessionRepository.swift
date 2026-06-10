//
//  SessionRepository.swift
//  MusicJourney
//
//  Created by Academy on 10/06/26.
//

import Foundation
import CoreData

class SessionRepository{
    let context = PersistenceController.shared.container.viewContext
   
    
    func createSession(for goal: Goal) -> Session{
        let newSession = Session(context: context)
        newSession.id = UUID()
        newSession.createdAt = Date()
        newSession.duration = 0
        newSession.goal = goal
        
        saveContext()
        return newSession
    }
    
    func updateSessionDuration(_ session: Session, newDuration: Int32){
        session.duration = newDuration
        saveContext()
    }
    
    func deleteSession(_ session: Session){
        context.delete(session)
        saveContext()
    }
    
    private func saveContext() {
        do {
            if context.hasChanges { try context.save() }
        } catch {
            print("Erro no SessionRepository: \(error) ")
        }
    }
    
}
