
import SwiftUI

// MARK: - Componente do Card de Áudio (Expansível)
struct RecordingCard: View {
    let recording: Recording
    @ObservedObject var audioService: AudioRecorderService
    let onEdit: () -> Void
    let onDelete: () -> Void
    
    // Identifica se este exato card é o que está tocando agora
    var isPlayingMe: Bool {
        guard let myURLString = recording.fileURL, let myURL = URL(string: myURLString) else { return false }
        return audioService.currentlyPlayingURL == myURL
    }
    
    var body: some View {
        VStack(spacing: 0) {
            
            // --- TOPO DO CARD ---
            HStack(spacing: 0) {
                // Lado Laranja
                ZStack {
                    Color("headerGreen").opacity(isPlayingMe ? 0.3 : 1.0)
                    Image(systemName: "mic.fill")
                        .font(.largeTitle)
                        .foregroundColor(isPlayingMe ? .black : .white)
                }
                .frame(width: 80)
                
                // Dados e Botões
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(recording.title ?? "Gravação sem nome")
                            .font(.headline)
                            .fontWeight(.bold)
                        
                        Text(formatDuration(recording.duration))
                            .font(.caption)
                            .foregroundColor(.gray)
                        
                        if let date = recording.createdAt {
                            Text(formatDate(date))
                                .font(.caption2)
                                .foregroundColor(.gray)
                        }
                    }
                    
                    Spacer()
                    
                    // Botão Play/Pause Dinâmico
                    Button(action: {
                        if isPlayingMe && audioService.isPlaying {
                            audioService.pauseAudio()
                        } else {
                            if let urlString = recording.fileURL, let url = URL(string: urlString) {
                                audioService.playAudio(url: url)
                            }
                        }
                    }) {
                        Image(systemName: (isPlayingMe && audioService.isPlaying) ? "pause.circle.fill" : "play.circle.fill")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.gray.opacity(0.8))
                    }
                    
                    // Os 3 Pontinhos
                    Menu {
                        Button(action: onEdit) {
                            Label("Editar nome", systemImage: "pencil")
                        }
                        Button(role: .destructive, action: onDelete) {
                            Label("Excluir", systemImage: "trash")
                        }
                    } label: {
                        Image(systemName: "ellipsis")
                            .rotationEffect(.degrees(90))
                            .foregroundColor(.gray)
                            .padding()
                    }
                }
                .padding()
                .background(isPlayingMe ? Color("headerGreen").opacity(0.1) : Color.white)
            }
            .frame(minHeight: 80)
            
            // --- ÁREA EXPANDIDA (O PLAYER) ---
            if isPlayingMe {
                VStack {
                    // Slider
                    HStack {
                        Text(formatDuration(audioService.currentTime))
                            .font(.caption2)
                            .foregroundColor(.gray)
                            .frame(width: 40)
                        
                        Slider(value: $audioService.currentTime, in: 0...audioService.duration) { editing in
                            if !editing {
                                audioService.seek(to: audioService.currentTime)
                                audioService.resumeAudio()
                            } else {
                                audioService.pauseAudio()
                            }
                        }
                        .accentColor(Color("headerGreen"))
                        
                        Text(formatDuration(audioService.duration))
                            .font(.caption2)
                            .foregroundColor(.gray)
                            .frame(width: 40)
                    }
                    .padding(.horizontal)
                    
                    // Controles extras (Voltar, Excluir, Avançar)
                    HStack(spacing: 40) {
                        Button(action: { audioService.skipBackward() }) {
                            Image(systemName: "gobackward.10").font(.title).foregroundColor(.black)
                        }
                        Button(action: onDelete) {
                            Image(systemName: "trash.fill").font(.title).foregroundColor(.black)
                        }
                        Button(action: { audioService.skipForward() }) {
                            Image(systemName: "goforward.10").font(.title).foregroundColor(.black)
                        }
                    }
                    .padding(.top, 8)
                }
                .padding(.vertical)
                .background(Color("headerGreen").opacity(0.1))
            }
        }
        .cornerRadius(16)
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color("headerGreen"), lineWidth: 1))
        .padding(.horizontal)
        .animation(.easeInOut, value: isPlayingMe)
    }
    
    private func formatDuration(_ duration: Double) -> String {
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        return String(format: "%dmin %02ds", minutes, seconds)
    }
    private func formatDate(_ date: Date) -> String {
        let f = DateFormatter(); f.dateFormat = "dd/MM/yyyy • HH:mm"; return f.string(from: date)
    }
}

