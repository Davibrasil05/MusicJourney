//
//  OnboardingFormView.swift
//  MusicJourney
//

import SwiftUI
import CoreData

// MARK: - Enums (temporary until CoreData model is finalised)

enum MusicLevel: String, CaseIterable, Identifiable {
    case iniciante     = "Iniciante"
    case intermediario = "Intermediário"
    case avancado      = "Avançado"

    var id: String { rawValue }

    var levelValue: Int16 {
        switch self {
        case .iniciante:     return 0
        case .intermediario: return 1
        case .avancado:      return 2
        }
    }
}

enum MusicInstrument: String, CaseIterable, Identifiable {
    case violao  = "Violão"
    case ukulele = "Ukulele"
    case teclado = "Teclado"
    case bateria = "Bateria"

    var id: String { rawValue }

    var assetName: String {
        switch self {
        case .violao:  return "instrument-violao"
        case .ukulele: return "instrument-ukulele"
        case .teclado: return "instrument-teclado"
        case .bateria: return "instrument-bateria"
        }
    }
}

enum MusicGenre: String, CaseIterable, Identifiable {
    case rock    = "Rock"
    case pop     = "Pop"
    case mpb     = "MPB"
    case jazz    = "Jazz"
    case samba   = "Samba"
    case gospel  = "Gospel"
    case pagode  = "Pagode"
    case classica = "Clássica"

    var id: String { rawValue }
}

enum PracticeSchedule: String, CaseIterable, Identifiable {
    case manha = "Manhã"
    case tarde = "Tarde"
    case noite = "Noite"

    var id: String { rawValue }

    var assetName: String {
        switch self {
        case .manha: return "schedule-manha"
        case .tarde: return "schedule-tarde"
        case .noite: return "schedule-noite"
        }
    }
}

// MARK: - Wizard Orchestrator

struct OnboardingFormView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @AppStorage("onboardingCompleted") private var onboardingCompleted = false

    @State private var currentStep: Int = 0
    @State private var direction: Int = 1

    @State private var selectedLevel: MusicLevel?
    @State private var selectedInstrument: MusicInstrument?
    @State private var selectedGenres: Set<MusicGenre> = []
    @State private var selectedSchedule: PracticeSchedule?

    private var canAdvance: Bool {
        switch currentStep {
        case 0: return true
        case 1: return selectedLevel != nil
        case 2: return selectedInstrument != nil
        case 3: return !selectedGenres.isEmpty
        case 4: return selectedSchedule != nil
        default: return false
        }
    }

    private var slideTransition: AnyTransition {
        let insertion = AnyTransition.move(edge: direction > 0 ? .trailing : .leading)
            .combined(with: .opacity)
        let removal   = AnyTransition.move(edge: direction > 0 ? .leading  : .trailing)
            .combined(with: .opacity)
        return .asymmetric(insertion: insertion, removal: removal)
    }

    var body: some View {
        ZStack {
            stepView
                .transition(slideTransition)
                .id(currentStep)
        }
        .animation(.easeInOut(duration: 0.3), value: currentStep)
    }

    // MARK: - Step router

    @ViewBuilder
    private var stepView: some View {
        switch currentStep {
        case 0:
            OnboardingWelcomeStep(
                currentStep: currentStep,
                onNext: advance
            )
        case 1:
            OnboardingLevelStep(
                currentStep: currentStep,
                selectedLevel: $selectedLevel,
                canAdvance: canAdvance,
                onBack: goBack,
                onNext: advance
            )
        case 2:
            OnboardingInstrumentStep(
                currentStep: currentStep,
                selectedInstrument: $selectedInstrument,
                canAdvance: canAdvance,
                onBack: goBack,
                onNext: advance
            )
        case 3:
            OnboardingGenreStep(
                currentStep: currentStep,
                selectedGenres: $selectedGenres,
                canAdvance: canAdvance,
                onBack: goBack,
                onNext: advance
            )
        case 4:
            OnboardingScheduleStep(
                currentStep: currentStep,
                selectedSchedule: $selectedSchedule,
                canAdvance: canAdvance,
                onBack: goBack,
                onFinish: finishOnboarding
            )
        default:
            EmptyView()
        }
    }

    // MARK: - Navigation

    private func advance() {
        direction = 1
        withAnimation(.easeInOut(duration: 0.3)) {
            currentStep += 1
        }
    }

    private func goBack() {
        direction = -1
        withAnimation(.easeInOut(duration: 0.3)) {
            currentStep -= 1
        }
    }

    // MARK: - Save

    private func finishOnboarding() {
        guard let level = selectedLevel, let instrument = selectedInstrument else { return }

        let user = User(context: viewContext)
        user.id = UUID()
        user.name = ""
        user.instrument = instrument.rawValue
        user.experienceLevel = level.rawValue
        user.level = level.levelValue
        user.xp = 0
        user.streak = 0
        user.practiceSchedule = selectedSchedule?.rawValue
        user.genres = selectedGenres.map(\.rawValue) as NSArray

        do {
            try viewContext.save()
            onboardingCompleted = true
        } catch {
            print("OnboardingFormView: save error — \(error as NSError)")
        }
    }
}

// MARK: - Shape helpers (shared across onboarding)

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
            .previewDisplayName("OnboardingFormView")
    }
}
