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
    @EnvironmentObject var floatingPlayerVM: FloatingPlayerViewModel
    
    @ObservedObject var viewModel: SessionViewModel
    @State private var goRecordsView = false
    @StateObject private var metronomeViewModel = PracticeSessionViewModel()
    
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
                    goalName: viewModel.currentGoal.name ?? "",
                    goalDescription: viewModel.currentGoal.textDescription ?? "",
                    onNoteTapped: { viewModel.openTool(.nota) },
                    onAudioTapped: { viewModel.openTool(.audio) },
                    onVideoTapped: { floatingPlayerVM.presentURLInput() },
                    onMetronomeTapped: { viewModel.openTool(.metronomo) },
                    onStartPracticeTapped: {
                        viewModel.completePractice()
                        presentationMode.wrappedValue.dismiss()
                    },
                    isFinishEnabled: viewModel.timeElapsed > 300
                )
                .frame(height: UIScreen.main.bounds.height * 0.65)
            }
            .ignoresSafeArea(edges: .bottom)
            
            // OVERLAY DA ANOTAÇÃO (BottomSheet falso)
            if viewModel.activeModal == .nota {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation {
                            viewModel.activeModal = nil
                        }
                    }
                
                AddNoteModalView(
                    annotationRepo: AnnotationRepository(),
                    goal: viewModel.currentGoal,
                    session: viewModel.activeSession,
                    onClose: {
                        withAnimation {
                            viewModel.activeModal = nil
                        }
                    }
                )
                .frame(height: UIScreen.main.bounds.height * 0.55) // Metade da tela
                .transition(.move(edge: .bottom))
                .zIndex(1) // Garante que fique acima de tudo
            }
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
                        .foregroundColor(.white)
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
                    .foregroundColor(.white)
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
        .sheet(item: Binding(
            get: { viewModel.activeModal == .nota ? nil : viewModel.activeModal },
            set: { newValue in
                if viewModel.activeModal != .nota {
                    viewModel.activeModal = newValue
                }
            }
        )) { modal in
            switch modal {
            case .audio:
                AddAudioModalView(recordingRepo: RecordingRepository(), goal: viewModel.currentGoal, session: viewModel.activeSession)
            case .metronomo:
                MetronomeOverlayView(viewModel: metronomeViewModel)
            default:
                EmptyView()
            }
        }
        .sheet(isPresented: $floatingPlayerVM.showURLInputSheet) {
            YoutubeURLInputSheet(
                onOpen: { videoID in
                    floatingPlayerVM.videoID = videoID
                    floatingPlayerVM.isExpanded = false
                    floatingPlayerVM.dragOffset = .zero
                    floatingPlayerVM.showURLInputSheet = false
                },
                onCancel: {
                    floatingPlayerVM.showURLInputSheet = false
                }
            )
        }
       
        .onChange(of: viewModel.timeElapsed) { _ in }
        .onReceive(viewModel.$showQuitAlert) { show in
        }
    }
}

