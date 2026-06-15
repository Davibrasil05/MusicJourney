//
//  UserProfileView.swift
//  MusicJourney
//
//  Created by Academy on 05/06/26.
//

import SwiftUI

struct UserProfileView: View {
    @StateObject private var viewModel = UserRepository()

    @State private var selectedInstrument: MusicInstrument = .violao
    @State private var selectedLevel: MusicLevel = .iniciante
    @State private var selectedSchedule: PracticeSchedule = .noite
    @State private var selectedGenres: Set<MusicGenre> = []

    var body: some View {
        NavigationView {
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

                        Button(action: { saveProfile(to: user) }) {
                            Text("Salvar")
                                .bold()
                                .foregroundColor(.white)
                                .padding(8)
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
                    VStack(alignment: .leading, spacing: 24) {
                        ProfileSectionHeader(title: "Perfil musical")

                        VStack(spacing: 12) {
                            ProfilePickerRow(
                                title: "Instrumento",
                                value: selectedInstrument.rawValue
                            ) {
                                Picker("Instrumento", selection: $selectedInstrument) {
                                    ForEach(MusicInstrument.allCases) { instrument in
                                        Text(instrument.rawValue).tag(instrument)
                                    }
                                }
                            }

                            ProfilePickerRow(
                                title: "Nível",
                                value: selectedLevel.rawValue
                            ) {
                                Picker("Nível", selection: $selectedLevel) {
                                    ForEach(MusicLevel.allCases) { level in
                                        Text(level.rawValue).tag(level)
                                    }
                                }
                            }

                            ProfilePickerRow(
                                title: "Horário de prática",
                                value: selectedSchedule.rawValue
                            ) {
                                Picker("Horário de prática", selection: $selectedSchedule) {
                                    ForEach(PracticeSchedule.allCases) { schedule in
                                        Text(schedule.rawValue).tag(schedule)
                                    }
                                }
                            }

                            ProfileCard {
                                Text(selectedSchedule.reminderSummaryLabel)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                    .fixedSize(horizontal: false, vertical: true)
                            }

                            // TEMP: remover antes do release — testar saída da notificação
                            Button(action: {
                                Task {
                                    await PracticeNotificationService.shared.sendTestNotification()
                                }
                            }) {
                                ProfileCard {
                                    HStack {
                                        Image(systemName: "bell.badge")
                                            .foregroundColor(Color("headerGreen"))
                                        Text("Testar notificação")
                                            .font(.body.bold())
                                            .foregroundColor(.black)
                                        Spacer()
                                    }
                                }
                            }
                            .buttonStyle(PlainButtonStyle())

                            NavigationLink(
                                destination: GenrePickerView(selectedGenres: $selectedGenres)
                            ) {
                                ProfileNavigationRow(
                                    title: "Gêneros",
                                    value: genresSummary
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
                    .padding(.horizontal, 20)
                    .padding(.top, 32)
                    .padding(.bottom, 120)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color("cardCream"))
                .clipShape(RoundedCorner(radius: 40, corners: [.topLeft, .topRight]))
                .ignoresSafeArea(edges: .bottom)
            }
        }
        .onAppear { loadProfile(from: user) }
    }

    private var genresSummary: String {
        selectedGenres.isEmpty
            ? "Nenhum"
            : selectedGenres.map(\.rawValue).sorted().joined(separator: ", ")
    }

    private func loadProfile(from user: User) {
        selectedInstrument = MusicInstrument(rawValue: user.instrument ?? "") ?? .violao
        selectedLevel = MusicLevel(rawValue: user.experienceLevel ?? "") ?? .iniciante
        selectedSchedule = PracticeSchedule(rawValue: user.practiceSchedule ?? "") ?? .noite
        let saved = user.genres as? [String] ?? []
        selectedGenres = Set(saved.compactMap { MusicGenre(rawValue: $0) })
    }

    private func saveProfile(to user: User) {
        user.instrument = selectedInstrument.rawValue
        user.experienceLevel = selectedLevel.rawValue
        user.level = selectedLevel.levelValue
        user.practiceSchedule = selectedSchedule.rawValue
        user.genres = selectedGenres.map(\.rawValue) as NSArray
        viewModel.save()

        Task {
            await PracticeNotificationService.shared.syncReminder(for: selectedSchedule)
        }
    }
}

// MARK: - Profile components

private struct ProfileSectionHeader: View {
    let title: String

    var body: some View {
        Text(title)
            .font(.headline)
            .foregroundColor(.black)
    }
}

private struct ProfileCard<Content: View>: View {
    @ViewBuilder let content: Content

    var body: some View {
        content
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color("backgroundCards"))
            .cornerRadius(16)
    }
}

private struct ProfilePickerRow<Content: View>: View {
    let title: String
    let value: String
    @ViewBuilder let picker: Content

    var body: some View {
        ProfileCard {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Text(value)
                        .font(.body.bold())
                        .foregroundColor(.black)
                }
                Spacer()
                picker
                    .labelsHidden()
                Image(systemName: "chevron.up.chevron.down")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
}

private struct ProfileInfoRow: View {
    let title: String
    let value: String
    let valueColor: Color

    var body: some View {
        ProfileCard {
            HStack {
                Text(title)
                    .font(.body)
                    .foregroundColor(.black)
                Spacer()
                Text(value)
                    .font(.body.bold())
                    .foregroundColor(valueColor)
            }
        }
    }
}

private struct ProfileNavigationRow: View {
    let title: String
    let value: String

    var body: some View {
        ProfileCard {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Text(value)
                        .font(.body.bold())
                        .foregroundColor(.black)
                        .lineLimit(2)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.caption.bold())
                    .foregroundColor(.secondary)
            }
        }
    }
}

// MARK: - Genre Picker

private struct GenrePickerView: View {
    @Binding var selectedGenres: Set<MusicGenre>

    var body: some View {
        ZStack {
            Color("cardCream").ignoresSafeArea()

            List {
                ForEach(MusicGenre.allCases) { genre in
                    Button(action: { toggle(genre) }) {
                        HStack {
                            Text(genre.rawValue)
                                .foregroundColor(.black)
                            Spacer()
                            if selectedGenres.contains(genre) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(Color("headerGreen"))
                            }
                        }
                    }
                    .listRowBackground(Color("backgroundCards"))
                }
            }
            .listStyle(.plain)
        }
        .navigationTitle("Gêneros")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func toggle(_ genre: MusicGenre) {
        if selectedGenres.contains(genre) {
            selectedGenres.remove(genre)
        } else {
            selectedGenres.insert(genre)
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
