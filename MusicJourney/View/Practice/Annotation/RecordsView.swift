//
//  RecordsView.swift
//  MusicJourney
//

import SwiftUI

struct RecordsView: View {
    @Environment(\.presentationMode) var presentationMode
    
    // Repositórios
    @StateObject var annotationRepo = AnnotationRepository()
    @StateObject var recordingRepo = RecordingRepository()
    @StateObject var audioService = AudioRecorderService()
    var goal: Goal
    
    @State private var selectedTab = 0 // 0 = Áudio, 1 = Notas
    
    // Controle Universal do Modal de Edição de Nome
    @State private var showingEditModal = false
    @State private var itemToEdit: EditItemType?
    @State private var newTitle: String = ""
    
    // Enum para saber se estamos editando um Áudio ou uma Nota
    enum EditItemType {
        case nota(Annotation)
        case audio(Recording)
    }
    
    // Cores do App
    let headerOrange = Color(red: 220/255, green: 110/255, blue: 0/255)
    let bgColor = Color(red: 235/255, green: 233/255, blue: 226/255)
    let primaryBlue = Color(red: 45/255, green: 58/255, blue: 180/255)
    
    var body: some View {
        ZStack {
            bgColor.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // ==========================================
                // HEADER LARANJA
                // ==========================================
                VStack(spacing: 16) {
                    HStack {
                        Button(action: { presentationMode.wrappedValue.dismiss() }) {
                            HStack {
                                Image(systemName: "chevron.left")
                                Text("Prática")
                            }
                            .foregroundColor(.black)
                        }
                        Spacer()
                    }
                    .padding(.horizontal)
                    
                    Text("Meus registros")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text("Acesse seus áudios e notas salvas")
                        .foregroundColor(.white.opacity(0.9))
                        .padding(.bottom, 24)
                }
                .padding(.top, 40)
                .background(headerOrange.ignoresSafeArea(edges: .top))
                
                // ==========================================
                // SEGMENTED CONTROL (Abas)
                // ==========================================
                HStack {
                    Button(action: { selectedTab = 0 }) {
                        Text("Audio")
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                            .background(selectedTab == 0 ? primaryBlue : Color.gray.opacity(0.2))
                            .foregroundColor(selectedTab == 0 ? .white : .black)
                            .cornerRadius(20)
                    }
                    
                    Button(action: { selectedTab = 1 }) {
                        Text("Notas")
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                            .background(selectedTab == 1 ? primaryBlue : Color.gray.opacity(0.2))
                            .foregroundColor(selectedTab == 1 ? .white : .black)
                            .cornerRadius(20)
                    }
                }
                .padding()
                .background(Color.white.opacity(0.5))
                .cornerRadius(24)
                .padding()
                
                // ==========================================
                // CONTEÚDO PRINCIPAL (Listas)
                // ==========================================
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        if selectedTab == 0 {
                            // --- ABA DE ÁUDIOS ---
                            let groupedRecordings = groupRecordingsByDate(recordingRepo.recordings)
                            
                            if groupedRecordings.isEmpty {
                                Text("Nenhum áudio encontrado. Comece a gravar!")
                                    .foregroundColor(.gray)
                                    .padding(.top, 40)
                                    .frame(maxWidth: .infinity, alignment: .center)
                            } else {
                                ForEach(groupedRecordings, id: \.date) { group in
                                    VStack(alignment: .leading, spacing: 16) {
                                        // Título da Data (Ex: 01/06/2026)
                                        HStack {
                                            Image(systemName: "calendar")
                                            Text(group.date)
                                                .fontWeight(.bold)
                                        }
                                        .padding(.horizontal)
                                        
                                        // Cards dos Áudios
                                        ForEach(group.items) { recording in
                                            RecordingCard(
                                                recording: recording,
                                                audioService: audioService,
                                                onEdit: {
                                                    itemToEdit = .audio(recording)
                                                    newTitle = recording.title ?? ""
                                                    withAnimation { showingEditModal = true }
                                                },
                                                onDelete: {
                                                    audioService.stopAudio()
                                                    recordingRepo.deleteRecording(recording)
                                                }
                                            )
                                        }
                                    }
                                }
                            }
                        } else {
                            // --- ABA DE NOTAS ---
                            HStack {
                                Image(systemName: "calendar")
                                Text("Recentes")
                                    .fontWeight(.bold)
                            }
                            .padding(.horizontal)
                            
                            if annotationRepo.annotations.isEmpty {
                                Text("Nenhuma anotação encontrada.")
                                    .foregroundColor(.gray)
                                    .padding(.top, 40)
                                    .frame(maxWidth: .infinity, alignment: .center)
                            } else {
                                ForEach(annotationRepo.annotations) { annotation in
                                    AnnotationCard(
                                        annotation: annotation,
                                        onEdit: {
                                            itemToEdit = .nota(annotation)
                                            newTitle = annotation.title ?? ""
                                            withAnimation { showingEditModal = true }
                                        },
                                        onDelete: {
                                            annotationRepo.deleteAnnotation(annotation)
                                        }
                                    )
                                }
                            }
                        }
                    }
                    .padding(.bottom, 30)
                }
            }
            
            // ==========================================
            // MODAL ESCURO (EDITAR NOME UNIVERSAL)
            // ==========================================
            if showingEditModal {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture { withAnimation { showingEditModal = false } }
                
                VStack(spacing: 20) {
                    HStack {
                        Spacer()
                        Text("Editar nome")
                            .font(.headline)
                            .fontWeight(.bold)
                        Spacer()
                        Button(action: { withAnimation { showingEditModal = false } }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray.opacity(0.6))
                                .font(.title)
                        }
                    }
                    
                    TextField("Digite o nome", text: $newTitle)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(8)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.orange, lineWidth: 1))
                    
                    HStack(spacing: 16) {
                        Button(action: { withAnimation { showingEditModal = false } }) {
                            Text("Cancelar")
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(12)
                        }
                        
                        Button(action: {
                            if let item = itemToEdit {
                                switch item {
                                case .nota(let ann):
                                    annotationRepo.updateAnnotation(annotation: ann, newTitle: newTitle, newText: nil)
                                case .audio(let rec):
                                    recordingRepo.updateRecordingTitle(recording: rec, newTitle: newTitle)
                                }
                            }
                            withAnimation { showingEditModal = false }
                        }) {
                            Text("Salvar")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(primaryBlue)
                                .cornerRadius(12)
                        }
                    }
                }
                .padding()
                .background(Color(red: 235/255, green: 233/255, blue: 226/255))
                .cornerRadius(24)
                .padding(.horizontal, 24)
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            annotationRepo.fetchAnnotations(for: goal)
            recordingRepo.fetchRecordings(goal: goal)
        }
        .onDisappear {
            audioService.stopAudio() // Para a música se fechar a tela
        }
    }
    
    // Agrupa as gravações pela data para ficarem separadas igual no Figma
    struct DateGroup {
        let date: String
        let items: [Recording]
    }
    
    func groupRecordingsByDate(_ recordings: [Recording]) -> [DateGroup] {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        
        let dictionary = Dictionary(grouping: recordings) { rec -> String in
            guard let date = rec.createdAt else { return "Desconhecido" }
            return formatter.string(from: date)
        }
        
        return dictionary.map { DateGroup(date: $0.key, items: $0.value) }
            .sorted { $0.date > $1.date }
    }
}

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
                    Color(red: 220/255, green: 110/255, blue: 0/255).opacity(isPlayingMe ? 0.3 : 1.0)
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
                .background(isPlayingMe ? Color.orange.opacity(0.1) : Color.white)
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
                        .accentColor(.orange)
                        
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
                .background(Color.orange.opacity(0.1))
            }
        }
        .cornerRadius(16)
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.orange, lineWidth: 1))
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

// MARK: - Componente do Card de Nota
struct AnnotationCard: View {
    let annotation: Annotation
    let onEdit: () -> Void
    let onDelete: () -> Void
    var body: some View {
        HStack(spacing: 0) {
            ZStack {
                Color(red: 220/255, green: 110/255, blue: 0/255)
                Image(systemName: "square.and.pencil").font(.largeTitle).foregroundColor(.white)
            }.frame(width: 80)
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(annotation.title ?? "Nota sem título").font(.headline).fontWeight(.bold)
                    Spacer()
                    Menu {
                        Button(action: onEdit) { Label("Editar nome", systemImage: "pencil") }
                        Button(role: .destructive, action: onDelete) { Label("Excluir", systemImage: "trash") }
                    } label: { Image(systemName: "ellipsis").rotationEffect(.degrees(90)).foregroundColor(.gray).padding(.horizontal, 8) }
                }
                Text(annotation.text ?? "").font(.caption).foregroundColor(.gray).lineLimit(2)
                if let date = annotation.createdAt {
                    Text(formatDate(date)).font(.caption2).foregroundColor(.gray)
                }
            }.padding().background(Color.white)
        }.cornerRadius(16).overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.orange, lineWidth: 1)).padding(.horizontal)
    }
    private func formatDate(_ date: Date) -> String {
        let f = DateFormatter(); f.dateFormat = "dd/MM/yyyy • HH:mm"; return f.string(from: date)
    }
}
