//
//  AddAudioModalView.swift
//  MusicJourney
//
//

import SwiftUI

struct AddAudioModalView: View {
    @Environment(\.presentationMode) var presentationMode
    
    // Inicia o gravador exclusivo dessa tela e recebe o banco de dados
    @StateObject var audioService = AudioRecorderService()
    @ObservedObject var recordingRepo: RecordingRepository
    
    var goal: Goal
    var session: Session?
    
    @State private var recordingName: String = ""
    @State private var isSaving = false
    
    let bgColor = Color(red: 235/255, green: 233/255, blue: 226/255)
    let primaryBlue = Color(red: 45/255, green: 58/255, blue: 180/255)
    
    var body: some View {
        VStack(spacing: 30) {
            
            // HEADER
            HStack {
                Spacer()
                Text(isSaving ? "Salvar Gravação" : "Gravar Áudio")
                    .font(.headline)
                    .fontWeight(.bold)
                Spacer()
                
                Button(action: {
                    if audioService.isRecording {
                        audioService.stopRecording()
                    }
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray.opacity(0.6))
                        .font(.title)
                }
            }
            .padding(.top, 24)
            
            if isSaving {
                // ==========================================
                // TELA 2: NOMEAR O ÁUDIO (Pós-gravação)
                // ==========================================
                VStack(spacing: 20) {
                    TextField("Dê um nome para o seu áudio", text: $recordingName)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                    
                    Button(action: {
                        if let url = audioService.lastRecordedAudioURL {
                            let duration = audioService.lastRecordingDuration
                            let finalName = recordingName.isEmpty ? "Gravação sem título" : recordingName
                            
                            // Salva no Core Data!
                            _ = recordingRepo.createRecording(
                                title: finalName,
                                fileURL: url.absoluteString,
                                duration: duration,
                                goal: goal,
                                session: session
                            )
                        }
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Salvar")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(primaryBlue)
                            .cornerRadius(12)
                    }
                }
            } else {
                // ==========================================
                // TELA 1: MICROFONE PULSANTE (Gravação)
                // ==========================================
                VStack(spacing: 40) {
                    ZStack {
                        Circle()
                            .fill(audioService.isRecording ? Color.red.opacity(0.2) : Color.gray.opacity(0.1))
                            .frame(width: 160, height: 160)
                        
                        Circle()
                            .fill(audioService.isRecording ? Color.red : Color.orange)
                            .frame(width: 100, height: 100)
                        
                        Image(systemName: "mic.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.white)
                    }
                    // A animação de pulsar quando grava
                    .scaleEffect(audioService.isRecording ? 1.1 : 1.0)
                    .animation(audioService.isRecording ? Animation.easeInOut(duration: 1.0).repeatForever() : .default, value: audioService.isRecording)
                    
                    Text(audioService.isRecording ? "Gravando..." : "")
                        .font(.title3)
                        .foregroundColor(audioService.isRecording ? .red : .black)
                    
                    Button(action: {
                        if audioService.isRecording {
                            audioService.stopRecording()
                            withAnimation { isSaving = true } // Troca para a tela de nomear
                        } else {
                            audioService.startRecording()
                        }
                    }) {
                        Text(audioService.isRecording ? "Parar Gravação" : "Iniciar Gravação")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(audioService.isRecording ? Color.black : primaryBlue)
                            .cornerRadius(12)
                    }
                }
                .padding(.top, 40)
            }
            Spacer()
        }
        .padding(.horizontal, 24)
        .background(bgColor.ignoresSafeArea())
        // Segurança: Para a gravação se o usuário arrastar a tela para baixo no susto
        .onDisappear {
            if audioService.isRecording { audioService.stopRecording() }
            audioService.stopAudio()
        }
    }
}
