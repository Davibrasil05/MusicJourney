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
    
    // Controle de Navegação Programática
    @State private var isNoteDetailActive = false
    @State private var noteToOpen: Annotation?
    
    // Enum para saber se estamos editando um Áudio ou uma Nota
    enum EditItemType {
        case nota(Annotation)
        case audio(Recording)
    }
    
    // Cores do App
    let headerOrange = Color("headerGreen")
    let bgColor = Color("cardCream")
    let primaryBlue = Color(red: 45/255, green: 58/255, blue: 180/255)
    
    var body: some View {
        ZStack(alignment: .top) {
            headerOrange.ignoresSafeArea()
            
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
                
                // ==========================================
                // ÁREA DE CONTEÚDO (CREME)
                // ==========================================
                VStack(spacing: 0) {
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
                            let groupedAnnotations = groupAnnotationsByDate(annotationRepo.annotations)
                            
                            if groupedAnnotations.isEmpty {
                                Text("Nenhuma anotação encontrada.")
                                    .foregroundColor(.gray)
                                    .padding(.top, 40)
                                    .frame(maxWidth: .infinity, alignment: .center)
                            } else {
                                ForEach(groupedAnnotations, id: \.date) { group in
                                    VStack(alignment: .leading, spacing: 16) {
                                        // Título da Data
                                        HStack {
                                            Image(systemName: "calendar")
                                            Text(group.date)
                                                .fontWeight(.bold)
                                        }
                                        .padding(.horizontal)
                                        
                                        // Cards das Anotações
                                        ForEach(group.items) { annotation in
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
                                            .onTapGesture {
                                                noteToOpen = annotation
                                                isNoteDetailActive = true
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .padding(.bottom, 30)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(bgColor)
            .clipShape(RoundedCorner(radius: 40, corners: [.topLeft, .topRight]))
            .ignoresSafeArea(edges: .bottom)
                
                // Link programático invisível para navegação
                NavigationLink(
                    destination: Group {
                        if let note = noteToOpen {
                            NoteDetailView(annotationRepo: annotationRepo, annotation: note)
                        } else {
                            EmptyView()
                        }
                    },
                    isActive: $isNoteDetailActive,
                    label: { EmptyView() }
                )
                .hidden()
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
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color("headerGreen"), lineWidth: 1))
                    
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
                .background(Color("cardCream"))
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
    
    struct AnnotationDateGroup {
        let date: String
        let items: [Annotation]
    }
    
    func groupAnnotationsByDate(_ annotations: [Annotation]) -> [AnnotationDateGroup] {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        
        let dictionary = Dictionary(grouping: annotations) { ann -> String in
            guard let date = ann.createdAt else { return "Desconhecido" }
            return formatter.string(from: date)
        }
        
        return dictionary.map { AnnotationDateGroup(date: $0.key, items: $0.value) }
            .sorted { $0.date > $1.date }
    }
}
