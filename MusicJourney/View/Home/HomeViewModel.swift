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
    
    init(objectiveRepo: ObjectiveRepository, userRepo: UserRepository) {
        self.objectiveRepo = objectiveRepo
        self.userRepo = userRepo
    }
    
    func loadHomeData() {
        self.currentUser = userRepo.currentUser
        userRepo.fetchUser()
        objectiveRepo.fetchObjectives()
        if let active = objectiveRepo.objectives.first(where: { $0.status == "active" }) {
            self.activeObjective = active
            
            let goals = (active.goals?.allObjects as? [Goal]) ?? []
            
            if goals.isEmpty {
                self.sortedGoals = []
            } else {
                self.viewState = .objectiveWithGoals
                
                self.sortedGoals = goals.sorted { $0.order < $1.order }
                
                self.currentGoal = self.sortedGoals.first(where: { $0.status != "completed" })
            }
        } else {
            self.activeObjective = nil
            self.viewState = .noObjective
            self.sortedGoals = []
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
    func addObjective(name: String, descriptionText: String) {
    
            objectiveRepo.addObjective(name: name, descriptionText: descriptionText)
            
            loadHomeData()
        }
    func addGoal(to objective: Objective, name: String, textDescription: String, category: String, difficulty: String, order: Int16) {
            
            objectiveRepo.addGoal(to: objective,
                                  name: name,
                                  textDescription: textDescription,
                                  category: category,
                                  difficulty: difficulty,
                                  order: order)
            
            loadHomeData()
        }
    func saveFullObjective(title: String, deadline: Date, reminderTime: Date, isDailyReminder: Bool, tempGoals: [TempGoal]) {
        
        let newObjective = objectiveRepo.addObjective(name: title,
                                                      descriptionText: "",
                                                      reminderTime: reminderTime,
                                                      isDailyReminder: isDailyReminder)
        
        for (index, tempGoal) in tempGoals.enumerated() {
            if tempGoal.title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { continue }
            
            objectiveRepo.addGoal(to: newObjective,
                                  name: tempGoal.title,
                                  textDescription: "",
                                  category: "Outros",
                                  difficulty: "Média",
                                  order: Int16(index + 1))
        }
        
        loadHomeData()
    }
   
}
