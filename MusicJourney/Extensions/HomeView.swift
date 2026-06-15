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
    @State private var showDeleteAlert = false
    @State private var goalToDelete: Goal?
    @State private var showObjectiveWarning = false
    
    
    var body: some View {
        ZStack(alignment: .top) {
            // O fundo da tela inteira agora passa a ser a cor laranja (headerGreen)
            Color("headerGreen").ignoresSafeArea()
            
            VStack(spacing: 0) {
                
                // 1. ÁREA SUPERIOR (LARANJA)
                VStack(spacing: 20) {
                    HStack() {
                        Text("Jornada")
                            .foregroundColor(.white)
                            .bold()
                            .font(.title2)
                        
                        Spacer()
                        
                        Button(action: { 
                            if viewModel.activeObjective != nil {
                                withAnimation {
                                    showObjectiveWarning = true
                                }
                            } else {
                                showingAddSheet = true 
                            }
                        }) {
                            Image(systemName: "plus")
                                .font(.title2)
                                .foregroundColor(.white)
                                .padding(8)
                                .background(Color.black.opacity(0.15))
                                .clipShape(Circle())
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)
                    
                    // INDICADOR DE NÍVEL
                    HStack(spacing: 16) {
                        Text("Lev. \(viewModel.currentUser?.level ?? 1)")
                            .bold()
                            .foregroundColor(.white)
                        
                        let xpAtual = Double(viewModel.currentUser?.xp ?? 0)
                        LevelProgressBar(percentage: xpAtual / 100.0)
                        
                        Text("\(Int(xpAtual))%")
                            .bold()
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 23)
                    .padding(.bottom, 30) // Respiro antes da caixa creme
                }
                
                // 2. CAIXA INFERIOR (CREME) - Onde ficam o Título e os Cards
                VStack(spacing: 15) {
                    // CARD DO OBJETIVO
                    HStack{
                        Text(viewModel.activeObjective?.name ?? "Crie um objetivo")
                            .font(.system(size: 22, weight: .bold))
                        
                            .foregroundColor(.black)
                            .padding(.top, 40) // Distância do topo curvo
                            .padding(.horizontal)
                        Spacer()
                        
                    }
                    
                    if viewModel.activeObjective == nil {
                        Spacer()
                        Text("Você não tem nenhum\nobjetivo criado")
                            .font(.subheadline)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.gray)
                            .padding(.bottom, 100)
                        Spacer()
                    } else if viewModel.sortedGoals.isEmpty {
                        Spacer()
                        Text("Você não tem \nnenhuma meta criada")
                            .font(.subheadline)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.gray)
                            .padding(.bottom, 100)
                        Spacer()
                    } else {
                        // LISTA DE METAS
                        List {
                            ForEach(viewModel.openGoals) { goal in
                                goalRow(for: goal)
                            }
                            
                            if !viewModel.completedGoals.isEmpty {
                                Text("Metas concluídas")
                                    .font(.system(size: 22, weight: .bold))
                                    .foregroundColor(.black)
                                    .padding(.top, 20)
                                    .padding(.horizontal, 15)
                                    .listRowSeparator(.hidden)
                                    .listRowBackground(Color.clear)
                                    .listRowInsets(EdgeInsets())
                                
                                ForEach(viewModel.completedGoals) { goal in
                                    goalRow(for: goal)
                                }
                            }
                        }
                        .listStyle(.plain) // Remove o fundo cinza da lista
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color("cardCream"))
                // Usando a RoundedCorner já existente no projeto para arredondar o topo
                .clipShape(RoundedCorner(radius: 40, corners: [.topLeft, .topRight]))
                .ignoresSafeArea(edges: .bottom)
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            viewModel.loadHomeData()
        }
        .alert("Excluir meta", isPresented: $showDeleteAlert, presenting: goalToDelete) { goal in
            // Os dois botões do popup
            Button("Cancelar", role: .cancel) {
                // Não faz nada, o iOS já fecha sozinho
            }
            
            Button("Excluir", role: .destructive) {
                // Função de deletar
                viewModel.deleteGoal(goal)
            }
        } message: { goal in
            // O texto pequeno debaixo do título
            Text("Tem certeza que deseja excluir?\nEssa ação não pode ser desfeita.")
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
        .overlay(
            Group {
                if viewModel.showCompletedPopup, let obj = viewModel.justCompletedObjective {
                    CompletedObjectivePopUp(
                        objectiveName: obj.name ?? "",
                        completionDate: obj.completedAt ?? Date(),
                        onClose: {
                            withAnimation {
                                viewModel.showCompletedPopup = false
                            }
                        }
                    )
                }
                
                if showObjectiveWarning {
                    ObjectiveWarning(
                        onCancel: {
                            withAnimation { showObjectiveWarning = false }
                        },
                        onConfirm: {
                            withAnimation { showObjectiveWarning = false }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                showingAddSheet = true
                            }
                        }
                    )
                }
            }
        )
        
    }
    
    private func goalRow(for goal: Goal) -> some View {
        let state = viewModel.getGoalState(for: goal)
        
        return GoalCardView(goalName: goal.name ?? "", state: state)
            .padding(.vertical, 10)
            .padding(.horizontal, 15)
            .onTapGesture { selectedGoal = goal }
            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                Button(role: .destructive) {
                    goalToDelete = goal
                    showDeleteAlert = true
                } label: {
                    Label("Deletar", systemImage: "trash")
                }
            }
            .listRowSeparator(.hidden)
            .listRowBackground(Color.clear)
            .listRowInsets(EdgeInsets())
    }
}
