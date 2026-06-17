//
//  EditModal.swift
//  MusicJourney
//
//  Created by Academy on 17/06/26.
//

import SwiftUI


struct EditModal: View {
    
    @ObservedObject var annotationRepo = AnnotationRepository()
    @ObservedObject var recordingRepo = RecordingRepository()
    
    @Binding var itemToEdit: EditItemType?
    @Binding var showingEditModal: Bool
    @Binding var newTitle: String
    
    
    var body: some View {
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
                        .background(Color("primaryBlue"))
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


