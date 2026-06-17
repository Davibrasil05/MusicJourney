//
//  RecordsView.swift
//  MusicJourney
//

import SwiftUI
enum EditItemType {
    case nota(Annotation)
    case audio(Recording)
}

struct RecordsView: View {
    @Environment(\.presentationMode) var presentationMode
    
    // Repositórios
    @StateObject var annotationRepo = AnnotationRepository()
    @StateObject var recordingRepo = RecordingRepository()
    @StateObject var audioService = AudioRecorderService()
    var goal: Goal
    
    
    // Controle Universal do Modal de Edição de Nome
    @State var showingEditModal = false
    @State var itemToEdit: EditItemType?
    @State var newTitle: String = ""
    
    // Controle de Navegação Programática
    @State var isNoteDetailActive = false
    @State var noteToOpen: Annotation?
    
    // Enum para saber se estamos editando um Áudio ou uma Nota
    
    // Cores do App
    let headerOrange = Color("headerGreen")
    let bgColor = Color("cardCream")
    let primaryBlue = Color("primaryBlue")
    
    var body: some View {
        ZStack(alignment: .top) {
            headerOrange.ignoresSafeArea()
            
            VStack(spacing: 0) {
                
                VStack(spacing: 16) {
                    HStack {
                        Button(action: { presentationMode.wrappedValue.dismiss() }) {
                            HStack {
                                Image(systemName: "chevron.left")
                                    .font(.system(size: 16, weight: .bold))
                                Text("Voltar")
                                    .font(.system(size: 18, weight: .medium))
                            }
                            
                            .foregroundColor(.white)
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
                SegmentControl(annotationRepo: annotationRepo, recordingRepo: recordingRepo, audioService: audioService, goal: goal, showingEditModal: $showingEditModal, newTitle: $newTitle, itemToEdit: $itemToEdit , isNoteDetailActive: $isNoteDetailActive, noteToOpen: $noteToOpen)
                
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
            
            if showingEditModal {
                EditModal(annotationRepo: annotationRepo, recordingRepo: recordingRepo, itemToEdit: $itemToEdit, showingEditModal: $showingEditModal, newTitle: $newTitle)
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
    
}
