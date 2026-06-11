//
//  HomeViewModel.swift
//  MusicJourney
//
//  Created by academy on 11/06/26.
//

import Foundation
import CoreData

// Os 3 estados possíveis da tela Home
enum HomeState {
    case noObjective          // Não tem objetivo (Mostra a tela vazia com incentivo)
    case objectiveWithoutGoals // Tem objetivo mas não tem metas (Mostra botão Gerar Metas)
    case objectiveWithGoals    // Tem objetivo e metas (Mostra a trilha para praticar)
}

class HomeViewModel: ObservableObject{
    
    // Repositórios injetados
    private let objectiveRepo: ObjectiveRepository
    private let userRepo: UserViewModel
    
    @Published var viewState: HomeState = .noObjective
    @Published var activeObjective: Objective?
    @Published var currentGoal: Goal?
    @Published var currentUser: User?
    
    init(objectiveRepo: ObjectiveRepository, userRepo: UserViewModel) {
        self.objectiveRepo = objectiveRepo
        self.userRepo = userRepo
    }
    
    // Chamado no .onAppear da HomeView
    func loadHomeData() {
        // 1. Carrega o usuário atual
        self.currentUser = userRepo.currentUser
        
        // 2. Busca o objetivo que está ativo
        // Assumindo que a lista já vem ordenada do repositório, pegamos o primeiro "active"
        if let active = objectiveRepo.objectives.first(where: { $0.status == "active" }) {
            self.activeObjective = active
            
            // 3. Verifica se tem metas
            let goals = (active.goals?.allObjects as? [Goal]) ?? []
            
            if goals.isEmpty {
                self.viewState = .objectiveWithoutGoals
            } else {
                self.viewState = .objectiveWithGoals
                // Descobre qual é a meta atual (a que está 'unlocked')
                self.currentGoal = goals.first(where: { $0.status == "unlocked" })
            }
        } else {
            // Nenhum objetivo ativo encontrado
            self.activeObjective = nil
            self.viewState = .noObjective
        }
        
        // 4. Checa o Streak assim que o app abre
        checkStreak()
    }
    
    // Verifica se o usuário quebrou a sequência
    private func checkStreak() {
        guard let user = currentUser else { return }
        
        // ATENÇÃO: Para isso funcionar, o seu modelo 'User' no CoreData precisa ter
        // um atributo chamado 'lastPracticeDate' do tipo Date.
        guard let lastPractice = user.value(forKey: "lastPracticeDate") as? Date else { return }
        
        let calendar = Calendar.current
        
        // Se a última prática não foi nem hoje nem ontem... o streak quebrou!
        if !calendar.isDateInToday(lastPractice) && !calendar.isDateInYesterday(lastPractice) {
            user.streak = 0
            userRepo.saveChanges()
            // Atualiza a view
            self.currentUser = user
        }
    }
    
}
