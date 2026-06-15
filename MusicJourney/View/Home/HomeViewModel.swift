import Foundation
import CoreData


enum HomeState {
    case noObjective
    case objectiveWithGoals
}

enum GoalState {
    case completed
    case active
    case locked
}

class HomeViewModel: ObservableObject {
    
    private let objectiveRepo: ObjectiveRepository
    private let userRepo: UserRepository
    
    @Published var viewState: HomeState = .noObjective
    @Published var activeObjective: Objective?
    @Published var currentGoal: Goal?
    @Published var currentUser: User?
    
    @Published var sortedGoals: [Goal] = []
    @Published var openGoals: [Goal] = []
    @Published var completedGoals: [Goal] = []
    
    // Popup state
    @Published var showCompletedPopup = false
    @Published var justCompletedObjective: Objective?
    
    init(objectiveRepo: ObjectiveRepository, userRepo: UserRepository) {
        self.objectiveRepo = objectiveRepo
        self.userRepo = userRepo
    }
    
    func loadHomeData() {
        let previousActiveId = self.activeObjective?.id
        
        self.currentUser = userRepo.currentUser
        userRepo.fetchUser()
        objectiveRepo.fetchObjectives()
        
        // Check if the previously active objective just became completed
        if let prevId = previousActiveId,
           let objective = objectiveRepo.objectives.first(where: { $0.id == prevId }),
           objective.status == "completed" {
            self.justCompletedObjective = objective
            self.showCompletedPopup = true
        }
        
        if let active = objectiveRepo.objectives.first(where: { $0.status == "active" }) {
            self.activeObjective = active
            
            let goals = (active.goals?.allObjects as? [Goal]) ?? []
            
            if goals.isEmpty {
                self.sortedGoals = []
                self.openGoals = []
                self.completedGoals = []
            } else {
                self.viewState = .objectiveWithGoals
                
                self.sortedGoals = goals.sorted { $0.order < $1.order }
                self.openGoals = self.sortedGoals.filter { $0.status != "completed" }
                self.completedGoals = self.sortedGoals.filter { $0.status == "completed" }
                
                self.currentGoal = self.sortedGoals.first(where: { $0.status != "completed" })
            }
        } else {
            self.activeObjective = nil
            self.viewState = .noObjective
            self.sortedGoals = []
            self.openGoals = []
            self.completedGoals = []
        }
        
    }
    
    func getGoalState(for goal: Goal) -> GoalState {
        if goal.status == "completed" {
            return .completed
        }
        
        if goal.id == currentGoal?.id {
            return .active
        }
        
        return .locked
    }
    
    func deleteGoal(_ goal: Goal) {
        // Chama o seu repositório para apagar do CoreData
        objectiveRepo.deleteGoal(goal: goal) // (Assumindo que você tenha essa função no repositório)
        
        // Recarrega os dados para a tela atualizar na mesma hora e a meta sumir visualmente
        loadHomeData()
    }

}
