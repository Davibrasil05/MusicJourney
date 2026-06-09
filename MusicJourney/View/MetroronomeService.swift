import Foundation
import AVFoundation

class MetronomeService {
    private var player: AVAudioPlayer?
    private var timer: Timer?
    
    var isPlaying: Bool = false
    
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
        startTimer()
    }
    
    func stop() {
        isPlaying = false
        timer?.invalidate() // Mata o laço de repetição na hora
        timer = nil
    }
    
    private func startTimer() {
        // Limpa qualquer timer antigo para não sobrepor batidas
        timer?.invalidate()
        
        // Toca a batida inicial imediatamente
        player?.currentTime = 0
        player?.play()
        
        // A matemática básica do metrônomo: 60 segundos divididos pelo BPM
        let interval = 60.0 / currentBPM
        
        // Cria um cronômetro infinito que dispara a cada intervalo
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { [weak self] _ in
            self?.player?.currentTime = 0 // Rebovina o áudio pro milissegundo zero
            self?.player?.play()          // Dispara o TOC!
        }
        
        // Esse comando vital impede que o metrônomo pare de bater enquanto
        // você estiver arrastando listas ou o slider na tela do aplicativo:
        if let timer = timer {
            RunLoop.main.add(timer, forMode: .common)
        }
    }
}
