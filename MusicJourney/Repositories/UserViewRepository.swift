//  UserViewModel.swift
//  MusicJourney
//
//  Created by Academy on 05/06/26.
//

import Foundation
import CoreData

class UserViewModel: ObservableObject {
    let context = PersistenceController.shared.container.viewContext
    @Published var currentUser: User?
    
    init() { fetchUser() }
    
    // MARK: - Buscando Perfil
    func fetchUser() {
        let request = NSFetchRequest<User>(entityName: "User")
        request.fetchLimit = 1 // Só precisamos de 1 usuário neste app
        
        do {
            let users = try context.fetch(request)
            if let firstUser = users.first {
                self.currentUser = firstUser
            } else {
                // Se o usuário entrar pela 1ª vez, nós criamos um perfil padrão zerado
                let newUser = User(context: context)
                newUser.id = UUID()
                newUser.name = "Novo Músico"
                
                // Valores vazios que serão preenchidos depois pelo Onboarding
                newUser.instrument = ""
                newUser.experienceLevel = "" // Mudou: Antes era level_instrument
                newUser.practiceSchedule = "" // Novo campo do Core Data
                // newUser.genres = nil (Transformable começa nulo, está correto)
                
                newUser.level = 1
                newUser.xp = 0 // Mudou: Antes era experience
                newUser.streak = 0
                
                try context.save()
                self.currentUser = newUser
            }
        } catch {
            print("Erro ao buscar User: \(error)")
        }
    }
    
    // MARK: - Onboarding Helper
    // Função para você chamar na última tela do Onboarding (Etapa 4)
    func completeOnboarding(experienceLevel: String, instrument: String, genres: [String], practiceSchedule: String) {
        guard let user = currentUser else { return }
        user.experienceLevel = experienceLevel
        user.instrument = instrument
        user.practiceSchedule = practiceSchedule
        
        // Transformable converte arrays do Swift para o Core Data
        user.genres = genres as NSObject
        
        saveChanges()
    }
    
    // MARK: - XP e Nível
    // Função divertida para testar a XP!
    func gainXP(amount: Int16) {
        guard let user = currentUser else { return }
        
        user.xp += amount // Atualizado para usar user.xp
        
        if user.xp >= 100 { // Se passar de 100XP, sobe de nível!
            user.level += 1
            user.xp = 0 // Reseta a XP para o próximo nível
        }
        saveChanges()
    }
    
    // MARK: - Streak (Sequência de dias)
    func incrementStreak() {
        guard let user = currentUser else { return }
        user.streak += 1
        saveChanges()
    }
    
    // MARK: - Save Helper
    func saveChanges() {
        do {
            try context.save()
        } catch {
            print("Erro ao salvar User: \(error)")
        }
    }
}
