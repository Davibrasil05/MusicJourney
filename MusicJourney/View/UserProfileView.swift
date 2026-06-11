//
//  UserProfileView.swift
//  MusicJourney
//
//  Created by Academy on 05/06/26.
//

import SwiftUI

struct UserProfileView: View {
    @StateObject private var viewModel = UserViewModel()
    
    // NOVO: Instanciando o repositório de objetivos e as variáveis do modal
    @StateObject private var objectiveRepo = ObjectiveRepository()
    @State private var showingAddSheet = false
    @State private var newObjectiveName = ""
    @State private var newObjectiveDescription = ""
    
    var body: some View {
        NavigationView {
            if let user = viewModel.currentUser {
                Form {
                    Section(header: Text("Quem é você?")) {
                        TextField("Seu Nome", text: Binding(
                            get: { user.name ?? "" }, set: { user.name = $0 }
                        ))
                        TextField("Qual seu instrumento?", text: Binding(
                            get: { user.instrument ?? "" }, set: { user.instrument = $0 }
                        ))
                        TextField("Nível (ex: Intermediário)", text: Binding(
                            get: { user.experienceLevel ?? "" }, set: { user.experienceLevel = $0 }
                        ))
                    }
                    
                    Section(header: Text("Sua Jornada (Status)")) {
                        HStack {
                            Text("Nível Musical")
                            Spacer()
                            Text("Lvl \(user.level)")
                                .fontWeight(.bold).foregroundColor(.blue)
                        }
                        
                        HStack {
                            Text("Experiência (XP)")
                            Spacer()
                            Text("\(user.xp) / 100 XP")
                                .foregroundColor(.green)
                        }
                        
                        HStack {
                            Text("Ofensiva (Dias Seguidos)")
                            Spacer()
                            Text("🔥 \(user.streak) dias")
                                .foregroundColor(.orange)
                        }
                    }
                    
                    // MARK: - Nova Seção: Ferramentas
                    Section(header: Text("Ferramentas de Prática")) {
                        // O Metrônomo
                        NavigationLink(destination: MetronomeOverlayView(viewModel: PracticeSessionViewModel())) {
                            HStack {
                                Image(systemName: "metronome.fill")
                                    .foregroundColor(.blue)
                                Text("Testar Metrônomo")
                            }
                        }
                        
                        // O GRAVADOR NOVO!
                        NavigationLink(destination: TestAudioRecordingView()) {
                            HStack {
                                Image(systemName: "mic.fill")
                                    .foregroundColor(.red)
                                Text("Testar Gravador")
                            }
                        }
                    }
                    
                    // MARK: - Nova Seção: Ferramentas de Teste
                    Section(header: Text("Ferramentas de Teste")) {
                        // Botão para criar objetivo
                        Button(action: { showingAddSheet = true }) {
                            HStack {
                                Image(systemName: "target")
                                    .foregroundColor(.purple)
                                Text("Criar Objetivo de Teste")
                            }
                        }
                        
                        // Um botão para você testar como a gamificação vai funcionar depois
                        Button(action: { viewModel.gainXP(amount: 15) }) {
                            Text("Praticar (Ganhar +15 XP)")
                                .frame(maxWidth: .infinity)
                                .foregroundColor(.white)
                        }
                        .padding()
                        .background(Color.green)
                        .cornerRadius(8)
                        .listRowBackground(Color.clear)
                    }
                }
                .navigationTitle("Meu Perfil")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Salvar") { viewModel.saveChanges() }
                    }
                }
                // NOVO: Modal para criação do Objetivo colado no final do Form
                .sheet(isPresented: $showingAddSheet) {
                    NavigationView {
                        Form {
                            Section(header: Text("O que você quer aprender?")) {
                                TextField("Nome (ex: Tocar a música X)", text: $newObjectiveName)
                                TextField("Descrição (opcional)", text: $newObjectiveDescription)
                            }
                        }
                        .navigationTitle("Novo Objetivo")
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbar {
                            ToolbarItem(placement: .navigationBarLeading) {
                                Button("Cancelar") {
                                    resetSheetState()
                                }
                            }
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button("Salvar") {
                                    if !newObjectiveName.isEmpty {
                                        // Salva no banco de dados usando o repositório instanciado ali em cima
                                        objectiveRepo.addObjective(name: newObjectiveName, descriptionText: newObjectiveDescription)
                                        resetSheetState()
                                    }
                                }
                                .disabled(newObjectiveName.isEmpty)
                            }
                        }
                    }
                }
            } else {
                ProgressView("Carregando perfil...")
            }
        }
    }
    
    // Helper para limpar os campos ao fechar a modal
    private func resetSheetState() {
        newObjectiveName = ""
        newObjectiveDescription = ""
        showingAddSheet = false
    }
}
