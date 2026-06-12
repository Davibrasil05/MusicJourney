//
//  PracticeTimerDisplay.swift
//  MusicJourney
//
//  Created by academy on 11/06/26.
//

import SwiftUI

struct PracticeTimerDisplay: View {
    var timeString: String
    
    var isRunning: Bool
    
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
        .contentShape(Rectangle())
        .onTapGesture {
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
