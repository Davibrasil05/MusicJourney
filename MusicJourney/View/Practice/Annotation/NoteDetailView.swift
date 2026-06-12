//
//  NoteDetailView.swift
//  MusicJourney
//
import SwiftUI
struct NoteDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var annotationRepo: AnnotationRepository
    @ObservedObject var annotation: Annotation
    
    @State private var text: String = ""
    @State private var showingEditModal = false
    @State private var newTitle: String = ""
    
    let headerOrange = Color(red: 220/255, green: 110/255, blue: 0/255)
    let bgColor = Color(red: 235/255, green: 233/255, blue: 226/255)
    let primaryBlue = Color(red: 45/255, green: 58/255, blue: 180/255)
    
    var body: some View {
        ZStack {
            bgColor.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header Laranja
                VStack(spacing: 16) {
                    HStack {
                        Button(action: {
                            saveNote()
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            HStack {
                                Image(systemName: "chevron.left")
                                   
                                Text("Meus registros")
                                    .fontWeight(.semibold)
                            }
                            .foregroundColor(.black)
                        }
                        
                        Spacer()
                        
                        Menu {
                            Button(action: {
                                newTitle = annotation.title ?? ""
                                withAnimation { showingEditModal = true }
                            }) {
                                Label("Editar nome", systemImage: "pencil")
                            }
                            Button(role: .destructive, action: {
                                annotationRepo.deleteAnnotation(annotation)
                                presentationMode.wrappedValue.dismiss()
                            }) {
                                Label("Excluir", systemImage: "trash")
                            }
                        } label: {
                            Image(systemName: "ellipsis")
                                .rotationEffect(.degrees(90))
                                .foregroundColor(.black)
                                .font(.title3)
                               
                        }
                    }
                    .padding(.horizontal)
                    
                    Text(annotation.title ?? "Nota sem título")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.bottom, 24)
                }
                .padding(.top, 50)
                .background(headerOrange.ignoresSafeArea(edges: .top))
                
                // Área de texto com cantos arredondados
                ZStack(alignment: .topLeading) {
                    Color(red: 247/255, green: 246/255, blue: 242/255)
                        .clipShape(RoundedCorner(radius: 32, corners: [.topLeft, .topRight]))
                        .ignoresSafeArea(edges: .bottom)
                    
                    TextEditor(text: $text)
                        .font(.body)
                        .foregroundColor(.black)
                        .padding(24)
                        .background(Color.clear)
                        
                }
            }
            
            // Modal Escuro (Editar Nome)
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
                            annotationRepo.updateAnnotation(annotation: annotation, newTitle: newTitle, newText: nil)
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
            self.text = annotation.text ?? ""
        }
        .onDisappear {
            saveNote()
        }
    }
    
    private func saveNote() {
        if text != annotation.text {
            annotationRepo.updateAnnotation(annotation: annotation, newTitle: nil, newText: text)
        }
    }
}

