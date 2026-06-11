import Foundation
import Combine
import CoreData // Precisamos importar para usar as entidades

// MARK: - Enums de Controle
enum PracticeModal: Identifiable {
    case nota, audio, tablatura, metronomo
    var id: Int { hashValue }
}

// MARK: - ViewModel
class SessionViewModel: ObservableObject {
    
    // DEPENDÊNCIAS
    let currentGoal: Goal
    private let sessionRepository: SessionRepository
    private let objectiveRepository: ObjectiveRepository
    
    // ESTADO DO BANCO
    @Published var activeSession: Session? // <-- Guardamos a sessão aqui!
    
    // ESTADO DO CRONÔMETRO
    @Published var timeElapsed: Int = 0
    @Published var timeString: String = "00:00"
    @Published var isRunning: Bool = false
    private var timer: Timer?
    
    // ESTADO DA INTERFACE
    @Published var showQuitAlert: Bool = false
    @Published var activeModal: PracticeModal? = nil
    
    // INICIALIZADOR
    init(goal: Goal, sessionRepo: SessionRepository, objectiveRepo: ObjectiveRepository) {
        self.currentGoal = goal
        self.sessionRepository = sessionRepo
        self.objectiveRepository = objectiveRepo
        
        // 1. Assim que a tela abre, nós já criamos a Sessão no banco com tempo 0!
        // Isso é ótimo porque se ele gravar um áudio, já temos a sessão para vincular.
        self.activeSession = sessionRepo.createSession(for: goal)
    }
    
    // MARK: - Controle do Cronômetro
    
    func toggleTimer() {
        if isRunning {
            pauseTimer()
        } else {
            startTimer()
        }
    }
    
    private func startTimer() {
        isRunning = true
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.tick()
        }
    }
    
    private func pauseTimer() {
        isRunning = false
        timer?.invalidate()
        timer = nil
    }
    
    private func tick() {
        timeElapsed += 1
        formatTime()
    }
    
    private func formatTime() {
        let minutes = timeElapsed / 60
        let seconds = timeElapsed % 60
        timeString = String(format: "%02d:%02d", minutes, seconds)
    }
    
    // MARK: - Ações da Tela
    
    func openTool(_ tool: PracticeModal) {
        activeModal = tool
    }
    
    /// O usuário quer voltar para a Home cancelando a prática
    func attemptToQuit() {
        pauseTimer()
        if timeElapsed > 0 {
            showQuitAlert = true
        } else {
            cancelSessionAndQuit()
        }
    }
    
    /// Se ele cancelar de verdade, deletamos aquela sessão vazia que criamos no init
    func cancelSessionAndQuit() {
        if let session = activeSession {
            sessionRepository.deleteSession(session)
        }
    }
    
    /// O usuário tocou em Iniciar/Concluir (O botão roxão)
    func completePractice() {
        pauseTimer()
        
        guard let session = activeSession else { return }
        
        // 2. Agora nós chamamos a sua função de UPDATE!
        sessionRepository.updateSessionDuration(session, newDuration: Int32(timeElapsed))
        
        // Finaliza o timer
        timer?.invalidate()
        
        // TODO: Ir para a tela de feedback
    }
}
