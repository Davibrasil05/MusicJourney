//
//  OnboardingFormView.swift
//  MusicJourney
//
//  Created by Academy on 05/06/26.
//

import SwiftUI
import CoreData

private enum OnboardingColors {
    static let headerGreen = Color("headerGreen")
    static let cardCream = Color("cardCream")
    static let inputGray = Color("inputGray")
    static let textDark = Color("textDark")
    static let buttonPurple = Color("buttonPurple")
}

enum MusicInstrument: String, CaseIterable, Identifiable {
    case violao = "Violão"
    case tambor = "Tambor"
    case pandeiro = "Pandeiro"

    var id: String { rawValue }

    var imageName: String {
        switch self {
        case .violao: return "instrument-violao"
        case .tambor: return "instrument-tambor"
        case .pandeiro: return "instrument-pandeiro"
        }
    }
}

enum MusicLevel: String, CaseIterable, Identifiable {
    case basico = "Básico"
    case intermediario = "Intermediário"
    case avancado = "Avançado"

    var id: String { rawValue }
}

struct OnboardingFormView: View {
    @Environment(\.managedObjectContext) private var viewContext

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
                    .background(OnboardingColors.headerGreen)

                formCard
                    .frame(maxHeight: .infinity)
            }
            .background(OnboardingColors.headerGreen.ignoresSafeArea())
        }
    }

    private var headerSection: some View {
        Text("Bem Vindo!")
            .font(.system(size: 28, weight: .bold))
            .foregroundColor(OnboardingColors.textDark)
            .frame(maxWidth: .infinity)
            .padding(.top, 56)
    }

    private var formCard: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 20) {
                Text("Vamos começar com formulário")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(OnboardingColors.textDark)
                    .frame(maxWidth: .infinity)
                    .multilineTextAlignment(.center)
                    .padding(.top, 24)
                    .padding(.bottom, 8)

                formField(title: "Nome") {
                    TextField("Seu nome", text: $name)
                        .font(.system(size: 16))
                        .foregroundColor(OnboardingColors.textDark)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 14)
                        .background(OnboardingColors.inputGray)
                        .cornerRadius(14)
                }

                formField(title: "Nível") {
                    Menu {
                        ForEach(MusicLevel.allCases) { level in
                            Button(level.rawValue) {
                                selectedLevel = level
                            }
                        }
                    } label: {
                        HStack {
                            Text(selectedLevel.rawValue)
                                .font(.system(size: 16))
                                .foregroundColor(OnboardingColors.textDark)
                            Spacer()
                            Image(systemName: "chevron.down")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(OnboardingColors.textDark.opacity(0.6))
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 14)
                        .background(OnboardingColors.inputGray)
                        .cornerRadius(14)
                    }
                }

                formField(title: "Qual seu principal instrumento?") {
                    HStack(spacing: 12) {
                        ForEach(MusicInstrument.allCases) { instrument in
                            InstrumentCard(
                                instrument: instrument,
                                isSelected: selectedInstrument == instrument
                            ) {
                                selectedInstrument = instrument
                            }
                        }
                    }
                }

                if showValidationError {
                    Text("Preencha seu nome e escolha um instrumento.")
                        .font(.system(size: 14))
                        .foregroundColor(.red)
                }

                Button(action: finishOnboarding) {
                    Text("Finalizar")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(OnboardingColors.textDark)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(OnboardingColors.buttonPurple)
                        .cornerRadius(28)
                }
                .padding(.top, 8)
                .padding(.bottom, 32)
            }
            .padding(.horizontal, 24)
        }
        .background(
            OnboardingColors.cardCream
                .cornerRadius(32, corners: [.topLeft, .topRight])
                .ignoresSafeArea(edges: .bottom)
        )
    }

    private func formField<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(OnboardingColors.textDark)

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
        user.level_instrument = selectedLevel.rawValue
        user.level = levelValue(for: selectedLevel)
        user.experience = 0
        user.streak = 0

        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }

    private func levelValue(for level: MusicLevel) -> Int16 {
        switch level {
        case .basico: return 0
        case .intermediario: return 1
        case .avancado: return 2
        }
    }
}

private struct InstrumentCard: View {
    let instrument: MusicInstrument
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(instrument.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 44, height: 44)

                Text(instrument.rawValue)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(OnboardingColors.textDark)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(OnboardingColors.inputGray)
            .cornerRadius(14)
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(isSelected ? OnboardingColors.buttonPurple : Color.clear, lineWidth: 3)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

private extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCornerShape(radius: radius, corners: corners))
    }
}

private struct RoundedCornerShape: Shape {
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

struct OnboardingFormView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingFormView()
            .environment(\.managedObjectContext, PersistenceController(inMemory: true).container.viewContext)
    }
}
