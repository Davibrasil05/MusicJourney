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
                        Text("Meu perfil")
                            .font(.title2)
                            .foregroundColor(.white)
                            .bold()

                        Spacer()
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
                                .pickerStyle(MenuPickerStyle())
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
                                .pickerStyle(MenuPickerStyle())
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
                                .pickerStyle(MenuPickerStyle())
                            }

                            ProfileCard {
                                Text(viewModel.selectedSchedule.reminderSummaryLabel)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                    .fixedSize(horizontal: false, vertical: true)
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
                            .padding(.top, 8)

                        VStack(spacing: 12) {
                            ProfileInfoRow(
                                title: "Nível Musical",
                                value: "Lev. \(user.level)"
                            )
                            ProfileInfoRow(
                                title: "Experiência",
                                value: "\(user.xp)%"
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
        .onChange(of: viewModel.selectedInstrument) { _ in
            viewModel.saveProfileChanges(to: user)
        }
        .onChange(of: viewModel.selectedLevel) { _ in
            viewModel.saveProfileChanges(to: user)
        }
        .onChange(of: viewModel.selectedSchedule) { _ in
            viewModel.saveProfileChanges(to: user)
        }
        .onChange(of: viewModel.genresSelectionKey) { _ in
            viewModel.saveProfileChanges(to: user)
        }
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
