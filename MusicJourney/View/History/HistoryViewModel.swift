//
//  HistoryViewModel.swift
//  MusicJourney
//
//  Created by academy on 11/06/26.
//

import Foundation
import Combine

class HistoryViewModel: ObservableObject {
    private let objectiveRepo: ObjectiveRepository
    let userRepo: UserRepository
    
    @Published var completedObjectives: [Objective] = []
    
    var currentUser: User? {
        userRepo.currentUser
    }
    
    init(objectiveRepo: ObjectiveRepository = ObjectiveRepository(), userRepo: UserRepository = UserRepository()) {
        self.objectiveRepo = objectiveRepo
        self.userRepo = userRepo
        loadCompletedObjectives()
    }
    
    func loadCompletedObjectives() {
        objectiveRepo.fetchObjectives()
        userRepo.fetchUser()
        
        let objectives = objectiveRepo.objectives.filter { $0.status == "completed" }
        self.completedObjectives = objectives.sorted { (obj1, obj2) -> Bool in
            let date1 = obj1.completedAt ?? Date.distantPast
            let date2 = obj2.completedAt ?? Date.distantPast
            return date1 > date2 // Mais recentes primeiro
        }
    }
}
