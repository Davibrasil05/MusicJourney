import Foundation

class PracticeSessionViewModel: ObservableObject {
    private var metronomeService = MetronomeService()
    
    @Published var isMetronomePlaying: Bool = false
    @Published var bpm: Double = 120.0 {
        didSet {
            metronomeService.currentBPM = bpm
        }
    }
    
    func toggleMetronome() {
        if isMetronomePlaying {
            metronomeService.stop()
            isMetronomePlaying = false
        } else {
            metronomeService.start()
            isMetronomePlaying = true
        }
    }
    
    func closeSession() {
        metronomeService.stop()
        isMetronomePlaying = false
    }
}
