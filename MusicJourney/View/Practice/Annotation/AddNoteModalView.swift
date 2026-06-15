//
//  AddNoteModalView.swift
//  MusicJourney
//
//

import SwiftUI

struct AddNoteModalView: View {
    @ObservedObject var annotationRepo: AnnotationRepository
    var goal: Goal
    var session: Session?
    var onClose: () -> Void
    
    @State private var noteTitle: String = ""
    @State private var noteText: String = ""
    
    init(annotationRepo: AnnotationRepository, goal: Goal, session: Session?, onClose: @escaping () -> Void) {
        self.annotationRepo = annotationRepo
        self.goal = goal
        self.session = session
        self.onClose = onClose
        // Hack garantido para remover o fundo branco do TextEditor no iOS 14/15
        UITextView.appearance().backgroundColor = .clear
    }
    
    // Cores exatas do seu Figma
    let bgColor = Color(red: 235/255, green: 233/255, blue: 226/255) // Bege de fundo do modal
    let fieldBgColor = Color(red: 226/255, green: 224/255, blue: 217/255) // Cinza dos textfields
    let primaryBlue = Color(red: 45/255, green: 58/255, blue: 180/255) // Azul do botão
    
    var body: some View {
        VStack(spacing: 20) {
            
            // HEADER (Título e botão de fechar)
            HStack {
                Spacer()
                Text("Adicionar Anotação")
                    .font(.headline)
                    .fontWeight(.bold)
                Spacer()
                
                Button(action: {
                    onClose()
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray.opacity(0.6))
                        .font(.title)
                }
            }
            .padding(.top, 24)
            
            // CAMPOS DE TEXTO
            VStack(spacing: 16) {
                
                // 1. Digite o Título
                TextField("Digite o Título", text: $noteTitle)
                    .padding()
                    .background(fieldBgColor)
                    .cornerRadius(30)
                    .overlay(
                        RoundedRectangle(cornerRadius: 30)
                            .stroke(Color.gray.opacity(0.5), lineWidth: 2)
                    )
                
                // 2. Digite sua anotação
                ZStack(alignment: .topLeading) {
                    if noteText.isEmpty {
                        Text("Digite sua anotação")
                            .foregroundColor(.gray.opacity(0.8))
                            .padding(.horizontal, 16)
                            .padding(.vertical, 16)
                    }
                    
                    TextEditor(text: $noteText)
                        .padding(8)
                        .background(Color.clear)
                }
                .frame(minHeight: 150)
                .background(fieldBgColor)
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.gray.opacity(0.5), lineWidth: 2)
                )
            }
            
            Spacer()
            
            // BOTÃO DE SALVAR
            Button(action: {
                // Salva no banco!
                annotationRepo.createAnnotation(title: noteTitle, text: noteText, goal: goal, session: session)
                // Fecha a tela!
                onClose()
            }) {
                Text("Salvar nota")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(primaryBlue)
                    .cornerRadius(50)
            }
            // Desativa o botão se o cara não digitar nada
            .disabled(noteTitle.isEmpty || noteText.isEmpty)
            .opacity((noteTitle.isEmpty || noteText.isEmpty) ? 0.6 : 1.0)
            .padding(.bottom, 16)
        }
        .padding(.horizontal, 24)
        .background(bgColor)
        .clipShape(RoundedCorner(radius: 32, corners: [.topLeft, .topRight]))
        .ignoresSafeArea(edges: .bottom)
    }
}
