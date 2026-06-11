//
//  Home.swift
//  MusicJourney
//
//  Created by Academy on 09/06/26.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel(objectiveRepo: ObjectiveRepository(), userRepo: UserViewModel())
    @State private var selectedGoal: Goal?
    @State private var showingAddSheet = false
    @State private var newGoalName = ""
    @State private var newGoalDescription = ""
    @State private var newGoalCategory = "Técnica"
    @State private var newGoalDifficulty = "Média"
    @State private var newGoalOrder: Int16 = 1
    
    let categories = ["Técnica", "Repertório", "Teoria", "Leitura", "Outros"]
    let difficulties = ["Fácil", "Média", "Difícil", "Mestre"]
    
    let backgroundColor = Color(red: 244/255, green: 241/255, blue: 234/255)
    
    var body: some View {
        ZStack {
            backgroundColor.ignoresSafeArea()
            
                VStack(spacing: 24) {
                    
                    HStack {
                        ZStack {
                            Circle().fill(Color.orange).frame(width: 50, height: 50)
                            Image(systemName: "flame.fill").foregroundColor(.white).font(.title)
                        }
                        
                        Spacer()
                        
                        // O botão só fica ativo se existir um objetivo! (Não dá pra criar meta do nada)
                        Button(action: { showingAddSheet = true }) {
                            Image(systemName: "plus")
                                .font(.title2)
                                .foregroundColor(viewModel.activeObjective == nil ? .gray.opacity(0.3) : .gray)
                                .padding(12)
                                .background(Color.gray.opacity(0.2))
                                .clipShape(Circle())
                        }
                    }.padding()
                    
                    // 2. INDICADOR DE NÍVEL (AGORA FUNCIONAL!)
                    HStack {
                        // Busca o level do usuário, ou mostra 1 se estiver carregando
                        Text("Lev. \(viewModel.currentUser?.level ?? 1)").bold()
                        
                        // Transforma a XP atual em porcentagem (ex: 45 / 100.0 = 0.45)
                        let xpAtual = Double(viewModel.currentUser?.xp ?? 0)
                        LevelProgressBar(percentage: xpAtual / 100.0)
                        
                        // Mostra o texto com o valor exato da XP
                        Text("\(Int(xpAtual))%").bold()
                    }.padding(.horizontal)
                    
                    // 3. CARD DO OBJETIVO (O grandão vermelho)
                    HStack {
                      
                        
                        // NOVO: Agora o texto não é mais fixo! Ele busca do banco de dados.
                        Text(viewModel.activeObjective?.name ?? "Crie um Objetivo Primeiro")
                            .font(.title)
                            .bold()
                        Spacer()
                            
                        
                    }
                    .padding(.horizontal)
                    .frame(height: 70)
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.15), radius: 5, x: 0, y: 3)
                    
                    // 4. LISTA DE METAS (Onde a mágica acontece)
                    ScrollView {
                    VStack(spacing: 16) {
                        ForEach(viewModel.sortedGoals) { goal in
                            let state = viewModel.getGoalState(for: goal)
                            
                            GoalCardView(goalName: goal.name ?? "", state: state)
                                .onTapGesture {
                                    if state == .active {
                                        selectedGoal = goal
                                    }
                            } else {
                                GoalCardView(goalName: goal.name ?? "", state: state)
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    Spacer(minLength: 100) // Espaço para Custom Tab Bar
                }
                
            }
        }
        .onAppear {
            viewModel.loadHomeData()
        }
        .sheet(isPresented: $showingAddSheet) {
            CreateObjectiveView(viewModel: viewModel)
        }
        .fullScreenCover(item: $selectedGoal, onDismiss: {
            viewModel.loadHomeData()
        }) { goal in
            NavigationView {
                PracticeSessionView(
                    viewModel: SessionViewModel(
                        goal: goal,
                        sessionRepo: SessionRepository(),
                        objectiveRepo: ObjectiveRepository()
                    )
                )
            }
        }
    }
    
    // Helper para limpar os campos
    private func resetSheetState() {
        newGoalName = ""
        newGoalDescription = ""
        newGoalCategory = "Técnica"
        newGoalDifficulty = "Média"
        newGoalOrder = 1
        showingAddSheet = false
    }
}
