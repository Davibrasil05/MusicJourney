//
//  PraticeSessionViewModel.swift
//  MusicJourney
//
//  Created by Academy on 09/06/26.
//

import Foundation

class PracticeSessionViewModel: ObservableObject {
    // 1. Instancie o serviço de áudio que acabamos de criar
    private var metronomeService = MetronomeService()
    
    // 2. Variáveis para a View (Tela) desenhar
    @Published var isMetronomePlaying: Bool = false
    @Published var bpm: Double = 120.0 {
        didSet {
            // Se alterar o Slider, atualiza o serviço imediatamente
            metronomeService.currentBPM = bpm
        }
    }
    
    // 3. Funções para os botões chamarem
    func toggleMetronome() {
        if isMetronomePlaying {
            metronomeService.stop()
            isMetronomePlaying = false
        } else {
            metronomeService.start()
            isMetronomePlaying = true
        }
    }
    
    // Lembrete: Ao concluir ou sair da sessão, não esqueça de desligar!
    func closeSession() {
        metronomeService.stop()
        isMetronomePlaying = false
        // ...resto da sua lógica de sair...
    }
}
