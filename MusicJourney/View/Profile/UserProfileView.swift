//
//  UserProfileView.swift
//  MusicJourney
//
//  Created by Academy on 05/06/26.
//

import SwiftUI

struct UserProfileView: View {
    @StateObject private var viewModel = UserProfileViewModel()

    var body: some View {
        Group {
            if let user = viewModel.currentUser {
                profileContent(for: user)
            } else {
                ZStack {
                    Color("headerGreen").ignoresSafeArea()
                    ProgressView("Carregando perfil...")
                        .foregroundColor(.white)
                }
            }
        }
        .navigationBarHidden(true)
    }

    private func profileContent(for user: User) -> some View {
        ZStack(alignment: .top) {
            Color("headerGreen").ignoresSafeArea()

            VStack(spacing: 0) {
                VStack(spacing: 20) {
                    HStack {
                        Text("Meu Perfil")
                            .font(.title2)
                            .foregroundColor(.white)
                            .bold()

                        Spacer()

                        // Componente invisível para forçar exatamente a mesma altura da HomeView/HistoryView
                        Image(systemName: "plus")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding(8)
                            .hidden()
                    }
                    .overlay(alignment: .trailing) {
                        Button(action: { viewModel.saveProfile(to: user) }) {
                            Text("Salvar")
                                .bold()
                                .foregroundColor(.white)
                                .padding(.vertical, 8)
                                .padding(.horizontal, 16)
                                .background(Color.black.opacity(0.15))
                                .clipShape(Capsule())
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)

                    HStack(spacing: 16) {
                        Text("Lev. \(user.level)")
                            .bold()
                            .foregroundColor(.white)

                        LevelProgressBar(percentage: Double(user.xp) / 100.0)

                        Text("\(user.xp)%")
                            .bold()
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 23)
                    .padding(.bottom, 30)
                }

                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 15) {
                        ProfileSectionHeader(title: "Perfil musical")
                            .padding(.top, 40)
                           

                        VStack(spacing: 12) {
                            ProfilePickerRow(
                                title: "Instrumento",
                                value: viewModel.selectedInstrument.rawValue
                            ) {
                                Picker("Instrumento", selection: $viewModel.selectedInstrument) {
                                    ForEach(MusicInstrument.allCases) { instrument in
                                        Text(instrument.rawValue).tag(instrument)
                                    }
                                }
                            }

                            ProfilePickerRow(
                                title: "Nível",
                                value: viewModel.selectedLevel.rawValue
                            ) {
                                Picker("Nível", selection: $viewModel.selectedLevel) {
                                    ForEach(MusicLevel.allCases) { level in
                                        Text(level.rawValue).tag(level)
                                    }
                                }
                            }

                            ProfilePickerRow(
                                title: "Horário de prática",
                                value: viewModel.selectedSchedule.rawValue
                            ) {
                                Picker("Horário de prática", selection: $viewModel.selectedSchedule) {
                                    ForEach(PracticeSchedule.allCases) { schedule in
                                        Text(schedule.rawValue).tag(schedule)
                                    }
                                }
                            }

                            NavigationLink(
                                destination: GenrePickerView(selectedGenres: $viewModel.selectedGenres)
                            ) {
                                ProfileNavigationRow(
                                    title: "Gêneros",
                                    value: viewModel.genresSummary
                                )
                            }
                            .buttonStyle(PlainButtonStyle())
                        }

                        ProfileSectionHeader(title: "Sua jornada")

                        VStack(spacing: 12) {
                            ProfileInfoRow(
                                title: "Nível musical",
                                value: "Lev. \(user.level)",
                                valueColor: Color("primaryBlue")
                            )
                            ProfileInfoRow(
                                title: "Experiência",
                                value: "\(user.xp)%",
                                valueColor: Color("headerGreen")
                            )
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 120)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color("cardCream"))
                .clipShape(RoundedCorner(radius: 40, corners: [.topLeft, .topRight]))
                .ignoresSafeArea(edges: .bottom)
            }
        }
        .onAppear { viewModel.loadProfile(from: user) }
    }

}

struct UserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        UserProfileView()
            .environment(\.managedObjectContext,
                         PersistenceController.preview.container.viewContext)
            .previewDisplayName("UserProfileView")
    }
}
