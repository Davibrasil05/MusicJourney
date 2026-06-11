import Foundation
import CoreData

// Os 3 estados possíveis da tela Home
enum HomeState {
    case noObjective          // Não tem objetivo (Mostra a tela vazia com incentivo)
    case objectiveWithoutGoals // Tem objetivo mas não tem metas (Mostra botão Gerar Metas)
    case objectiveWithGoals    // Tem objetivo e metas (Mostra a trilha para praticar)
}

// NOVO: Os estados visuais do card da Meta
enum GoalState {
    case completed
    case active
    case locked
}

class HomeViewModel: ObservableObject {
    
    private let objectiveRepo: ObjectiveRepository
    private let userRepo: UserViewModel
    
    @Published var viewState: HomeState = .noObjective
    @Published var activeObjective: Objective?
    @Published var currentGoal: Goal?
    @Published var currentUser: User?
    
    // NOVO: Array ordenado de metas para a View conseguir fazer o ForEach e desenhar os cards
    @Published var sortedGoals: [Goal] = []
    
    init(objectiveRepo: ObjectiveRepository, userRepo: UserViewModel) {
        self.objectiveRepo = objectiveRepo
        self.userRepo = userRepo
    }
    
    func loadHomeData() {
        self.currentUser = userRepo.currentUser
        objectiveRepo.fetchObjectives()
        if let active = objectiveRepo.objectives.first(where: { $0.status == "active" }) {
            self.activeObjective = active
            
            let goals = (active.goals?.allObjects as? [Goal]) ?? []
            
            if goals.isEmpty {
                self.viewState = .objectiveWithoutGoals
                self.sortedGoals = [] // Garante que a lista está vazia
            } else {
                self.viewState = .objectiveWithGoals
                
                // NOVO: Ordena as metas pelo 'order' (passo 1, passo 2...)
                self.sortedGoals = goals.sorted { $0.order < $1.order }
                
                // NOVO: A meta atual passa a ser a primeira que NÃO está concluída
                self.currentGoal = self.sortedGoals.first(where: { $0.status != "completed" })
            }
        } else {
            self.activeObjective = nil
            self.viewState = .noObjective
            self.sortedGoals = []
        }
        
//        checkStreak()
    }
    
    // NOVO: Função que a View vai chamar para saber a cor/ícone do Card
    func getGoalState(for goal: Goal) -> GoalState {
        // Se já concluiu, é completed
        if goal.status == "completed" {
            return .completed
        }
        
        // Se a meta que estamos desenhando agora for igual a currentGoal, ela está ativa!
        if goal.id == currentGoal?.id {
            return .active
        }
        
        // Se não é completed e não é a ativa, só pode estar bloqueada (ainda vai chegar lá)
        return .locked
    }
    func addObjective(name: String, descriptionText: String) {
            // Manda o repositório salvar no Core Data
            objectiveRepo.addObjective(name: name, descriptionText: descriptionText)
            
            // Chama o loadHomeData para a tela atualizar e mostrar o objetivo vermelho!
            loadHomeData()
        }
    func addGoal(to objective: Objective, name: String, textDescription: String, category: String, difficulty: String, order: Int16) {
            
            // Repassa para o Repository fazer a mágica no Core Data
            objectiveRepo.addGoal(to: objective,
                                  name: name,
                                  textDescription: textDescription,
                                  category: category,
                                  difficulty: difficulty,
                                  order: order)
            
            // Atualiza a tela pra exibir o novo card na mesma hora
            loadHomeData()
        }
   
//    private func checkStreak() {
//        guard let user = currentUser else { return }
//
//        guard let lastPractice = user.value(forKey: "lastPracticeDate") as? Date else { return }
//
//        let calendar = Calendar.current
//
//        if !calendar.isDateInToday(lastPractice) && !calendar.isDateInYesterday(lastPractice) {
//            user.streak = 0
//            userRepo.saveChanges()
//            self.currentUser = user
//        }
//    }
}
