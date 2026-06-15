//
//  GoalsView.swift
//  MusicJourney
//
//  Created by Academy on 12/06/26.
//

import SwiftUI

struct GoalsView: View {
    let objective: Objective
    @Environment(\.presentationMode) var presentationMode
    
    private var sortedGoals: [Goal] {
        let allGoals = objective.goals?.allObjects as? [Goal] ?? []
        return allGoals.sorted { $0.order < $1.order }
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            Color("headerGreen").ignoresSafeArea() // Cor laranja base
            
            VStack(spacing: 0) {
                // 1. ÁREA SUPERIOR (LARANJA)
                VStack(spacing: 20) {
                    HStack() {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Image(systemName: "chevron.left")
                                .font(.title2)
                                .foregroundColor(.white)
                                .padding(8)
                                .background(Color.black.opacity(0.15))
                                .clipShape(Circle())
                        }
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)
                    
                    Spacer().frame(height: 10)
                }
                
                // 2. CAIXA INFERIOR (CREME)
                VStack(spacing: 15) {
                    HStack{
                        Text("Suas metas de \(objective.name ?? "")")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                            .multilineTextAlignment(.leading)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.top, 40)
                            .padding(.horizontal)
                            .lineLimit(2)
                            .truncationMode(.tail)
                        
                        Spacer()
                        
                    }
                    
                    if sortedGoals.isEmpty {
                        Spacer()
                        Text("Você não tem \nnenhuma meta criada")
                            .font(.subheadline)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.gray)
                            .padding(.bottom, 100)
                        Spacer()
                    } else {
                        ScrollView(showsIndicators: false) {
                            VStack(spacing: 16) {
                                ForEach(sortedGoals) { goal in
                                    NavigationLink(destination: RecordsView(goal: goal)) {
                                        GoalCardView(goalName: goal.name ?? "", state: .completed)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            .padding(.top, 10)
                            .padding(.bottom, 120)
                            .padding(.horizontal, 15)
                        }
                    }
                }
               
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color("cardCream"))
                .clipShape(RoundedCorner(radius: 40, corners: [.topLeft, .topRight]))
                .ignoresSafeArea(edges: .bottom)
            }
        }
        .navigationBarHidden(true)
    }
}

