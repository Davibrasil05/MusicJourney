import Foundation
import Combine
import CoreData

class PracticeViewModel: ObservableObject {
    @Published var activeSession: Session?
    @Published var timeElapsed: Int32 = 0
    @Published var isPracticing = false
    
    // O timer que vai rodar em segundo plano
    private var timer: Timer?
    private let sessionRepository = SessionRepository() // Seu repository
    
    // Variável mágica que transforma "65 segundos" em "01:05"
    var formattedTime: String {
        let minutes = timeElapsed / 60
        let seconds = timeElapsed % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    func startPractice(for goal: Goal) {
        self.activeSession = sessionRepository.createSession(for: goal)
        self.isPracticing = true
        self.timeElapsed = 0
        
        // Inicia o cronômetro disparando a cada 1.0 segundo
        self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.timeElapsed += 1
        }
    }
    
    func finishPractice() {
        guard let session = activeSession else { return }
        
        // 1. Para o timer imediatamente
        self.timer?.invalidate()
        self.timer = nil
        self.isPracticing = false
        
        // 2. Salva no Core Data
        sessionRepository.updateSessionDuration(session, newDuration: timeElapsed)
    }
}
