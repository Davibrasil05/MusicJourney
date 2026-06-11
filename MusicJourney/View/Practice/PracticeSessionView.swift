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
    @State private var goRecordsView = false
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
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    goRecordsView = true // <- Mude a ação do botão
                }) {
                    Image(systemName: "folder.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.black)
                }
                .background(
                    NavigationLink(destination: RecordsView(goal: viewModel.currentGoal), isActive: $goRecordsView) { EmptyView() }
                )
            }
            
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
            
        }
        .alert(isPresented: $viewModel.showQuitAlert) {
            Alert(
                title: Text("Sair da Prática?"),
                message: Text("Você não vai ganhar XP se sair agora."),
                primaryButton: .destructive(Text("Sair")) {
                    viewModel.cancelSessionAndQuit()
                    presentationMode.wrappedValue.dismiss()
                },
                secondaryButton: .cancel(Text("Continuar")) {
                    viewModel.toggleTimer()
                }
            )
        }
        .sheet(item: $viewModel.activeModal) { modal in
            switch modal {
            case .nota:
                AddNoteModalView(annotationRepo: AnnotationRepository(), goal: viewModel.currentGoal, session: viewModel.activeSession)
            case .audio: 
                AddAudioModalView(recordingRepo: RecordingRepository(), goal: viewModel.currentGoal, session: viewModel.activeSession)
            case .tablatura:
                Text("Modal de Tablatura Aqui")
            case .metronomo:
                MetronomeOverlayView(viewModel: PracticeSessionViewModel())
            }
        }
       
        .onChange(of: viewModel.timeElapsed) { _ in }
        .onReceive(viewModel.$showQuitAlert) { show in
        }
    }
}

