//
//  PracticeView.swift
//  MusicJourney
//
//  Created by Academy on 10/06/26.
//
// PracticeSessionView.swift
import SwiftUI

struct PracticeSessionView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    // Agora a tela recebe a ViewModel real que você nomeou como SessionViewModel
    @ObservedObject var viewModel: SessionViewModel
    
    var body: some View {

        ZStack(alignment: .bottom) {
            
            Color("headerGreen")
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                
                PracticeTimerDisplay(
                    timeString: viewModel.timeString,
                    isRunning: viewModel.isRunning,
                    onTapped: {
                        viewModel.toggleTimer()
                    }
                )
                
                Spacer()
                
                PracticeBottomSheet(
                    onNoteTapped: { viewModel.openTool(.nota) },
                    onAudioTapped: { viewModel.openTool(.audio) },
                    onTabTapped: { viewModel.openTool(.tablatura) },
                    onMetronomeTapped: { viewModel.openTool(.metronomo) },
                    onStartPracticeTapped: {
                        viewModel.completePractice()
                    }
                )
                .frame(height: UIScreen.main.bounds.height * 0.65)
            }
            .ignoresSafeArea(edges: .bottom)
        }
        .ignoresSafeArea(edges: .bottom)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    // Lógica segura de fechar a tela
                    if viewModel.timeElapsed > 0 {
                        viewModel.attemptToQuit() // Pausa e mostra o alerta
                    } else {
                        viewModel.cancelSessionAndQuit() // Deleta a sessão vazia
                        presentationMode.wrappedValue.dismiss() // Volta pra Home direto
                    }
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16, weight: .bold))
                        Text("Voltar")
                            .font(.system(size: 18, weight: .medium))
                    }
                    .foregroundColor(.black)
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    print("Ver arquivos passados")
                }) {
                    Image(systemName: "folder.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.black)
                }
            }
        }
        // O alerta de saída que é disparado pela ViewModel
        .alert(isPresented: $viewModel.showQuitAlert) {
            Alert(
                title: Text("Sair da Prática?"),
                message: Text("Você não vai ganhar XP se sair agora."),
                primaryButton: .destructive(Text("Sair")) {
                    viewModel.cancelSessionAndQuit()
                    presentationMode.wrappedValue.dismiss()
                },
                secondaryButton: .cancel(Text("Continuar")) {
                    viewModel.toggleTimer() // Volta a rodar o tempo
                }
            )
        }
        // Exemplo de como abrir as modais quando a variável activeModal mudar
        .sheet(item: $viewModel.activeModal) { modal in
            switch modal {
            case .nota:
                Text("Modal de Anotação Aqui")
            case .audio:
                Text("Modal de Áudio Aqui")
            case .tablatura:
                Text("Modal de Tablatura Aqui")
            case .metronomo:
                Text("Modal de Metrônomo Aqui")
            }
        }
        // Observa se o tempo estava zerado e o usuário mandou sair, fechando a tela
        .onChange(of: viewModel.timeElapsed) { _ in }
        .onReceive(viewModel.$showQuitAlert) { show in
            // Fallback: Se ele tentou sair com 0 segundos, o showQuitAlert continua false
            // Mas o timeElapsed seria 0. A ViewModel lida com deleteSession lá dentro.
            // Para fechar a tela direto quando tempo = 0, melhor fazer via callback ou verificar.
        }
    }
}

// MARK: - Preview
// O preview precisaria de um mock do CoreData para funcionar agora,
// por isso eu comentei ele temporariamente para não quebrar seu Canvas.
/*
struct PracticeSessionView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            // PracticeSessionView(viewModel: mockViewModel)
        }
    }
}
*/
