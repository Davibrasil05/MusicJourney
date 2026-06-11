import SwiftUI

struct MetronomeOverlayView: View {
    @ObservedObject var viewModel: PracticeSessionViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            // Fundo da cor creme que você usa
            Color("cardCream")
                .ignoresSafeArea()
            
            VStack(spacing: 32) {
                // 1. Header (Top)
                MetronomeHeader(onClose: {
                    presentationMode.wrappedValue.dismiss()
                })
                
                Spacer().frame(height: 16)
                
                // 2. Display BPM
                DisplayBPM(bpm: viewModel.bpm)
                
                // 3. Display Compasso
                DisplayCompass(
                    beatsPerMeasure: viewModel.beatsPerMeasure,
                    onTap: {
                        viewModel.cycleTimeSignature()
                    }
                )
                
                Spacer().frame(height: 16)
                
                // 4. Bolinhas Indicadoras
                BeatIndicatorView(
                    currentBeat: viewModel.currentBeat,
                    beatsPerMeasure: viewModel.beatsPerMeasure,
                    isPlaying: viewModel.isMetronomePlaying
                )
                
                Spacer()
                
                // 5. Card Controle (Slider + Play)
                BPMControl(
                    bpm: $viewModel.bpm,
                    isPlaying: viewModel.isMetronomePlaying,
                    onTogglePlay: {
                        viewModel.toggleMetronome()
                    }
                )
                .padding(.horizontal, 24)
                
                // 6. Ajustes Finos (Rodapé)
                BPMAdjustButtonsView(
                    onDecrement: {
                        if viewModel.bpm > 40 { viewModel.bpm -= 1 }
                    },
                    onIncrement: {
                        if viewModel.bpm < 240 { viewModel.bpm += 1 }
                    },
                    onStop: {
                        viewModel.closeSession()
                    }
                )
                .padding(.bottom, 40)
            }
        }
    }
}

// MARK: - Preview
struct MetronomeOverlayView_Previews: PreviewProvider {
    static var previews: some View {
        MetronomeOverlayView(viewModel: PracticeSessionViewModel())
    }
}
