import Foundation
import AVFoundation

class MetronomeService {
    private var player: AVAudioPlayer?
    private var timer: Timer?
    
    var isPlaying: Bool = false
    
    // NOVO: Controle de compasso e batida atual
    var beatsPerMeasure: Int = 4
    var currentBeat: Int = 0
    
    // NOVO: Callback que avisa a ViewModel qual beat está tocando agora
    var onBeat: ((Int) -> Void)?
    
    var currentBPM: Double = 120.0 {
        didSet {
            // Se o usuário deslizar o Slider, reiniciamos o ritmo instantaneamente
            if isPlaying {
                startTimer()
            }
        }
    }
    
    init() {
        // DICA: Se você usou um arquivo .mp3 em vez de .wav, não esqueça de mudar a extensão aqui!
        guard let url = Bundle.main.url(forResource: "click1", withExtension: "mp3") else {
            print("⚠️ Aviso: Arquivo click não encontrado no projeto.")
            return
        }
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.prepareToPlay() // Deixa o áudio engatilhado na memória para não ter delay
        } catch {
            print("Erro ao inicializar o player de áudio: \(error)")
        }
    }
    
    func start() {
        guard !isPlaying else { return }
        isPlaying = true
        currentBeat = 0
        startTimer()
    }
    
    func stop() {
        isPlaying = false
        timer?.invalidate() // Mata o laço de repetição na hora
        timer = nil
        currentBeat = 0
    }
    
    private func startTimer() {
        // Limpa qualquer timer antigo para não sobrepor batidas
        timer?.invalidate()
        
        // Toca a batida inicial imediatamente
        player?.currentTime = 0
        player?.play()
        currentBeat = 1
        onBeat?(currentBeat)
        
        // A matemática básica do metrônomo: 60 segundos divididos pelo BPM
        let interval = 60.0 / currentBPM
        
        // Cria um cronômetro infinito que dispara a cada intervalo
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.player?.currentTime = 0 // Rebobina o áudio pro milissegundo zero
            self.player?.play()          // Dispara o TOC!
            
            // Avança a batida e reseta ao chegar no fim do compasso
            self.currentBeat += 1
            if self.currentBeat > self.beatsPerMeasure {
                self.currentBeat = 1
            }
            self.onBeat?(self.currentBeat)
        }
        
        // Esse comando vital impede que o metrônomo pare de bater enquanto
        // você estiver arrastando listas ou o slider na tela do aplicativo:
        if let timer = timer {
            RunLoop.main.add(timer, forMode: .common)
        }
    }
}
