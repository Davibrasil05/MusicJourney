//
//  PracticeTimerDisplay.swift
//  MusicJourney
//
//  Created by academy on 11/06/26.
//

import SwiftUI

struct PracticeTimerDisplay: View {
    // A string do tempo atual (ex: "00:00" ou "05:30")
    var timeString: String
    
    // Para mudar o texto de instrução dependendo do estado
    var isRunning: Bool
    
    // Ação que será executada quando o usuário tocar no cronômetro
    var onTapped: () -> Void
    
    var body: some View {
        VStack(spacing: 4) {
            Text(timeString)
                .font(.system(size: 64, weight: .bold, design: .rounded))
                .foregroundColor(.white)
            
            Text(isRunning ? "Toque para pausar" : "Toque para iniciar")
                .font(.system(size: 22, weight: .medium))
                .foregroundColor(.white)
        }
        // contentShape garante que clicar no espaço vazio entre os textos também conte como toque
        .contentShape(Rectangle())
        .onTapGesture {
            // Avisa a View/ViewModel principal que o usuário tocou aqui
            onTapped()
        }
    }
}

// MARK: - Preview
struct PracticeTimerDisplay_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            // Simulando o fundo laranja/marrom da sua tela para podermos ver as letras brancas
            Color("headerGreen")
                .ignoresSafeArea()
            
            VStack(spacing: 40) {
                PracticeTimerDisplay(timeString: "00:00", isRunning: false) {
                    print("Tocou para iniciar")
                }
                
                PracticeTimerDisplay(timeString: "04:20", isRunning: true) {
                    print("Tocou para pausar")
                }
            }
        }
    }
}
