//
//  MetronomeOverlayView.swift
//  MusicJourney
//
//  Created by Academy on 09/06/26.
//

import SwiftUI

struct MetronomeOverlayView: View {
    // Passamos a mesma ViewModel que está na tela de Prática
    @ObservedObject var viewModel: PracticeSessionViewModel
    
    var body: some View {
        VStack(spacing: 12) {
            Text("Metrônomo")
                .font(.headline)
            
            HStack(spacing: 20) {
                // Botão Ligar/Desligar
                Button(action: {
                    viewModel.toggleMetronome()
                }) {
                    Image(systemName: viewModel.isMetronomePlaying ? "pause.circle.fill" : "play.circle.fill")
                        .font(.system(size: 44))
                        .foregroundColor(viewModel.isMetronomePlaying ? .orange : .blue)
                }
                
                // Controle de BPM
                VStack(alignment: .leading) {
                    Text("\(Int(viewModel.bpm)) BPM")
                        .font(.subheadline)
                        .fontWeight(.bold)
                    
                    Slider(value: $viewModel.bpm, in: 40...240, step: 1)
                        .accentColor(.blue)
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(16)
        }
        .padding()
    }
}
