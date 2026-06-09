//
//  OnboardingFormView.swift
//  MusicJourney
//

import SwiftUI
import CoreData

// MARK: - Temporary enums (will be replaced with CoreData attributes)

enum MusicInstrument: String, CaseIterable, Identifiable {
    case violao   = "Violão"
    case tambor   = "Tambor"
    case pandeiro = "Pandeiro"

    var id: String { rawValue }

    var sfSymbol: String {
        switch self {
        case .violao:   return "guitars"
        case .tambor:   return "music.note.list"
        case .pandeiro: return "waveform"
        }
    }
}

enum MusicLevel: String, CaseIterable, Identifiable {
    case basico        = "Básico"
    case intermediario = "Intermediário"
    case avancado      = "Avançado"

    var id: String { rawValue }

    var levelValue: Int16 {
        switch self {
        case .basico:        return 0
        case .intermediario: return 1
        case .avancado:      return 2
        }
    }
}

// MARK: - View

struct OnboardingFormView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @AppStorage("onboardingCompleted") private var onboardingCompleted = false

    @State private var name = ""
    @State private var selectedLevel: MusicLevel = .basico
    @State private var selectedInstrument: MusicInstrument?
    @State private var showValidationError = false

    private var canFinish: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && selectedInstrument != nil
    }

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                headerSection
                    .frame(height: geometry.size.height * 0.18)
                    .background(Color("headerGreen"))

                formCard
                    .frame(maxHeight: .infinity)
            }
            .background(Color("headerGreen").ignoresSafeArea())
        }
    }

    // MARK: - Header

    private var headerSection: some View {
        Text("Bem Vindo!")
            .font(.system(size: 28, weight: .bold))
            .foregroundColor(Color("textDark"))
            .frame(maxWidth: .infinity)
            .padding(.top, 56)
    }

    // MARK: - Card

    private var formCard: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 20) {
                Text("Vamos começar com formulário")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(Color("textDark"))
                    .frame(maxWidth: .infinity)
                    .multilineTextAlignment(.center)
                    .padding(.top, 24)
                    .padding(.bottom, 8)

                formField(title: "Nome") {
                    TextField("Seu nome", text: $name)
                        .font(.system(size: 16))
                        .foregroundColor(Color("textDark"))
                        .padding(.horizontal, 16)
                        .padding(.vertical, 14)
                        .background(Color("inputGray"))
                        .cornerRadius(14)
                }

                formField(title: "Nível") {
                    Menu {
                        ForEach(MusicLevel.allCases) { level in
                            Button(level.rawValue) { selectedLevel = level }
                        }
                    } label: {
                        HStack {
                            Text(selectedLevel.rawValue)
                                .font(.system(size: 16))
                                .foregroundColor(Color("textDark"))
                            Spacer()
                            Image(systemName: "chevron.down")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(Color("textDark").opacity(0.6))
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 14)
                        .background(Color("inputGray"))
                        .cornerRadius(14)
                    }
                }

                formField(title: "Qual seu principal instrumento?") {
                    HStack(spacing: 12) {
                        ForEach(MusicInstrument.allCases) { instrument in
                            OnboardingInstrumentCard(
                                title: instrument.rawValue,
                                sfSymbol: instrument.sfSymbol,
                                isSelected: selectedInstrument == instrument,
                                onTap: { selectedInstrument = instrument }
                            )
                        }
                    }
                }

                if showValidationError {
                    Text("Preencha seu nome e escolha um instrumento.")
                        .font(.system(size: 14))
                        .foregroundColor(.red)
                }

                OnboardingPrimaryButton(
                    title: "Finalizar",
                    isEnabled: canFinish,
                    action: finishOnboarding
                )
                .padding(.top, 8)
                .padding(.bottom, 32)
            }
            .padding(.horizontal, 24)
        }
        .background(
            Color("cardCream")
                .cornerRadius(32, corners: [.topLeft, .topRight])
                .ignoresSafeArea(edges: .bottom)
        )
    }

    // MARK: - Helpers

    private func formField<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(Color("textDark"))
            content()
        }
    }

    private func finishOnboarding() {
        guard canFinish, let instrument = selectedInstrument else {
            showValidationError = true
            return
        }

        let user = User(context: viewContext)
        user.id = UUID()
        user.name = name.trimmingCharacters(in: .whitespacesAndNewlines)
        user.instrument = instrument.rawValue
        user.experienceLevel = selectedLevel.rawValue
        user.level = selectedLevel.levelValue
        user.xp = 0
        user.streak = 0

        do {
            try viewContext.save()
            onboardingCompleted = true
        } catch {
            print("OnboardingFormView: save error — \(error as NSError)")
        }
    }
}

// MARK: - Shape helpers

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCornerShape(radius: radius, corners: corners))
    }
}

struct RoundedCornerShape: Shape {
    var radius: CGFloat
    var corners: UIRectCorner

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

// MARK: - Preview

struct OnboardingFormView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingFormView()
            .environment(
                \.managedObjectContext,
                 PersistenceController(inMemory: true).container.viewContext
            )
    }
}
