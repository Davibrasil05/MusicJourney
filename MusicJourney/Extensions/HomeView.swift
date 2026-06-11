//
//  Home.swift
//  MusicJourney
//
//  Created by Academy on 09/06/26.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel(objectiveRepo: ObjectiveRepository(), userRepo: UserRepository())
    @State private var selectedGoal: Goal?
    @State private var showingAddSheet = false

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
                        
                        Button(action: { showingAddSheet = true }) {
                            Image(systemName: "plus")
                                .font(.title2)
                                .foregroundColor(.gray)
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
                            
                            if state == .active {
                                GoalCardView(goalName: goal.name ?? "", state: state)
                                    .onTapGesture {
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
            CreateObjectiveView(onFinish: {
                showingAddSheet = false
                viewModel.loadHomeData()
            })
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
    
}
