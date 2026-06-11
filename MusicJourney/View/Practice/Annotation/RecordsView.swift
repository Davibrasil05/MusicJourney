//
//  RecordsView.swift
//  MusicJourney
//
//

import SwiftUI

struct RecordsView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject var annotationRepo = AnnotationRepository()
    var goal: Goal // Precisamos saber de qual meta buscar os registros
    
    @State private var selectedTab = 1 // 0 = Audio, 1 = Notas
    
    // Controle do Modal de Edição de Nome
    @State private var showingEditModal = false
    @State private var annotationToEdit: Annotation?
    @State private var newTitle: String = ""
    
    // Cores aproximadas do seu Figma
    let headerOrange = Color(red: 220/255, green: 110/255, blue: 0/255)
    let bgColor = Color(red: 235/255, green: 233/255, blue: 226/255)
    let primaryBlue = Color(red: 45/255, green: 58/255, blue: 180/255)
    
    var body: some View {
        ZStack {
            bgColor.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // 1. HEADER LARANJA
                VStack(spacing: 16) {
                    HStack {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
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
                
                // 2. SEGMENTED CONTROL CUSTOMIZADO
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
                
                // 3. CONTEÚDO (Lista de Notas)
                ScrollView {
                    if selectedTab == 1 {
                        VStack(alignment: .leading, spacing: 16) {
                            
                            // Ícone de Calendário (Data Atual como no design)
                            HStack {
                                Image(systemName: "calendar")
                                Text(Date().formatted(.dateTime.day().month().year()))
                                    .fontWeight(.bold)
                            }
                            .padding(.horizontal)
                            
                            // Lista de Cards criados
                            ForEach(annotationRepo.annotations) { annotation in
                                AnnotationCard(
                                    annotation: annotation,
                                    onEdit: {
                                        annotationToEdit = annotation
                                        newTitle = annotation.title ?? ""
                                        withAnimation { showingEditModal = true }
                                    },
                                    onDelete: {
                                        annotationRepo.deleteAnnotation(annotation)
                                    }
                                )
                            }
                        }
                        .padding(.bottom, 30)
                    } else {
                        Text("Lista de áudios em breve...")
                            .foregroundColor(.gray)
                            .padding(.top, 40)
                    }
                }
            }
            
            // ==========================================
            // MODAL DE EDIÇÃO DE NOME (Sobreposição)
            // ==========================================
            if showingEditModal {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture { withAnimation { showingEditModal = false } }
                
                VStack(spacing: 20) {
                    HStack {
                        Spacer()
                        Text("Editar nome da nota")
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
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.orange, lineWidth: 1)
                        )
                    
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
                            if let ann = annotationToEdit {
                                annotationRepo.updateAnnotation(annotation: ann, newTitle: newTitle, newText: nil)
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
            // Toda vez que essa tela abre, ela puxa as anotações do banco
            annotationRepo.fetchAnnotations(for: goal)
        }
    }
}

// MARK: - Componente do Card de Anotação (O laranja e branco)
struct AnnotationCard: View {
    let annotation: Annotation
    let onEdit: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        HStack(spacing: 0) {
            // Lado Laranja
            ZStack {
                Color(red: 220/255, green: 110/255, blue: 0/255)
                Image(systemName: "square.and.pencil")
                    .font(.largeTitle)
                    .foregroundColor(.white)
            }
            .frame(width: 80)
            
            // Lado Branco (Conteúdo)
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(annotation.title ?? "Nota sem título")
                        .font(.headline)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    // Menu dos 3 pontinhos nativo do iOS
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
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                    }
                }
                
                Text(annotation.text ?? "")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .lineLimit(2) // Corta o texto para caber no card
                
                if let date = annotation.createdAt {
                    Text(formatDate(date))
                        .font(.caption2)
                        .foregroundColor(.gray)
                }
            }
            .padding()
            .background(Color.white)
        }
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.orange, lineWidth: 1)
        )
        .padding(.horizontal)
    }
    
    private func formatDate(_ date: Date) -> String {
        let f = DateFormatter()
        f.dateFormat = "dd/MM/yyyy • HH:mm"
        return f.string(from: date)
    }
}
