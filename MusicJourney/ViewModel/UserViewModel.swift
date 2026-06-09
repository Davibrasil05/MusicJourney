//
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
    
    func fetchUser() {
        let request = NSFetchRequest<User>(entityName: "User")
        request.fetchLimit = 1 // Só precisamos de 1 usuário neste app
        
        do {
            let users = try context.fetch(request)
            if let firstUser = users.first {
                self.currentUser = firstUser
            } else {
                // Se o usuário entrar pela 1ª vez, nós criamos um perfil padrão
                let newUser = User(context: context)
                newUser.id = UUID()
                newUser.name = "Novo Músico"
                newUser.instrument = "Violão"
                newUser.experienceLevel = "Iniciante"
                newUser.level = 1
                newUser.xp = 0
                newUser.streak = 0
                
                try context.save()
                self.currentUser = newUser
            }
        } catch {
            print("Erro ao buscar User: \(error)")
        }
    }
    
    func saveChanges() {
        do { try context.save() } catch { print("Erro ao salvar User: \(error)") }
    }
    
    // Função divertida para testar a XP!
    func gainXP(amount: Int16) {
        guard let user = currentUser else { return }
        user.xp += amount
        if user.xp >= 100 { // Se passar de 100XP, sobe de nível!
            user.level += 1
            user.xp = 0 // Reseta a XP para o próximo nível
        }
        saveChanges()
    }
}
