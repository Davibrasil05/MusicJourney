//
//  SegmentControl.swift
//  MusicJourney
//
//  Created by Academy on 17/06/26.
//

import SwiftUI


struct SegmentControl: View {
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var annotationRepo = AnnotationRepository()
    @ObservedObject var recordingRepo = RecordingRepository()
    @ObservedObject var audioService = AudioRecorderService()
    var goal: Goal
    
    
    @Binding var showingEditModal: Bool
    @Binding var newTitle: String
    @Binding var itemToEdit: EditItemType?
    
    // Controle de Navegação Programática
    @Binding var isNoteDetailActive: Bool
    @Binding var noteToOpen: Annotation?
    @State var selectedTab: Int = 0
    
    let headerOrange = Color("headerGreen")
    let bgColor = Color("cardCream")
    let primaryBlue = Color("primaryBlue")
    
    var body: some View {
        VStack(spacing: 0) {
           
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
                    AudioTab(goal:goal, recordingRepo: recordingRepo, audioService: audioService, showingEditModal: $showingEditModal, newTitle: $newTitle, itemToEdit: $itemToEdit)
                } else {
                    // --- ABA DE NOTAS ---
                    AnnotationTab(goal: goal, annotationRepo: annotationRepo, showingEditModal: $showingEditModal, newTitle: $newTitle,  itemToEdit: $itemToEdit, isNoteDetailActive: $isNoteDetailActive, noteToOpen: $noteToOpen)
                }
            }
            .padding(.bottom, 30)
        }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color("cardCream"))
    .clipShape(RoundedCorner(radius: 40, corners: [.topLeft, .topRight]))
    .ignoresSafeArea(edges: .bottom)
    .onAppear()
    }
    
}
