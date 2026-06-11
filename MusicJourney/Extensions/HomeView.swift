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
            backgroundColor.ignoresSafeArea()

            VStack(spacing: 20) {

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
                }
                .padding(.horizontal)
                .padding(.top, 8)

                // INDICADOR DE NÍVEL
                HStack {
                    Text("Lev. \(viewModel.currentUser?.level ?? 1)").bold()

                    let xpAtual = Double(viewModel.currentUser?.xp ?? 0)
                    LevelProgressBar(percentage: xpAtual / 100.0)

                    Text("\(Int(xpAtual))%").bold()
                }
                .padding(.horizontal)

                // CARD DO OBJETIVO
                HStack {
                    Text(viewModel.activeObjective?.name ?? "Crie um Objetivo Primeiro")
                        .font(.title)
                        .bold()
                    Spacer()
                }
                .padding(.horizontal)
                .frame(height: 70, alignment: .center)
                .cornerRadius(12)
                .shadow(color: .black.opacity(0.15), radius: 5, x: 0, y: 3)

                // LISTA DE METAS
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
                    .padding(.bottom, 100)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
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
