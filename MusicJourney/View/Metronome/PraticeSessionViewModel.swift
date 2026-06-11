import Foundation

class PracticeSessionViewModel: ObservableObject {
    private var metronomeService = MetronomeService()
    
    @Published var isMetronomePlaying: Bool = false
    @Published var currentBeat: Int = 0
    @Published var beatsPerMeasure: Int = 4
    
    @Published var bpm: Double = 120.0 {
        didSet {
            metronomeService.currentBPM = bpm
        }
    }
    
    init() {
        // Quando o Service toca uma batida, ele avisa a ViewModel para atualizar a UI
        metronomeService.onBeat = { [weak self] beat in
            DispatchQueue.main.async {
                self?.currentBeat = beat
            }
        }
    }
    
    func toggleMetronome() {
        if isMetronomePlaying {
            metronomeService.stop()
            isMetronomePlaying = false
            currentBeat = 0
        } else {
            metronomeService.beatsPerMeasure = beatsPerMeasure
            metronomeService.start()
            isMetronomePlaying = true
        }
    }
    
    /// Alterna entre os compassos disponíveis: 2/4, 3/4, 4/4, 6/8
    func cycleTimeSignature() {
        let options = [2, 3, 4, 6]
        if let currentIndex = options.firstIndex(of: beatsPerMeasure) {
            let nextIndex = (currentIndex + 1) % options.count
            beatsPerMeasure = options[nextIndex]
        } else {
            beatsPerMeasure = 4
        }
        metronomeService.beatsPerMeasure = beatsPerMeasure
        
        // Se estiver tocando, reinicia para aplicar o novo compasso
        if isMetronomePlaying {
            metronomeService.stop()
            metronomeService.start()
        }
    }
    
    func closeSession() {
        metronomeService.stop()
        isMetronomePlaying = false
        currentBeat = 0
    }
}
