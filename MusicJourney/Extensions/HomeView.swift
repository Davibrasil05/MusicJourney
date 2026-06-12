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
        ZStack(alignment: .top) {
            // O fundo da tela inteira agora passa a ser a cor laranja (headerGreen)
            Color("headerGreen").ignoresSafeArea()

            VStack(spacing: 0) {
                
                // 1. ÁREA SUPERIOR (LARANJA)
                VStack(spacing: 20) {
                    HStack {
                        ZStack {
                            Circle().fill(Color.orange.opacity(0.8)).frame(width: 50, height: 50)
                            Image(systemName: "flame.fill").foregroundColor(.white).font(.title)
                        }

                        Spacer()

                        Button(action: { showingAddSheet = true }) {
                            Image(systemName: "plus")
                                .font(.title2)
                                .foregroundColor(.white)
                                .padding(12)
                                .background(Color.black.opacity(0.15))
                                .clipShape(Circle())
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)

                    // INDICADOR DE NÍVEL
                    HStack {
                        Text("Lev. \(viewModel.currentUser?.level ?? 1)")
                            .bold()
                            .foregroundColor(.white)

                        let xpAtual = Double(viewModel.currentUser?.xp ?? 0)
                        LevelProgressBar(percentage: xpAtual / 100.0)

                        Text("\(Int(xpAtual))%")
                            .bold()
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 30) // Respiro antes da caixa creme
                }
                
                // 2. CAIXA INFERIOR (CREME) - Onde ficam o Título e os Cards
                VStack(spacing: 30) {
                    // CARD DO OBJETIVO
                    Text(viewModel.activeObjective?.name ?? "Crie um Objetivo Primeiro")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.black)
                        .padding(.top, 40) // Distância do topo curvo

                    // LISTA DE METAS
                    ScrollView {
                        VStack(spacing: 20) {
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
                        .padding(.horizontal, 15)
                        .padding(.bottom, 100)
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
