//
//  OnboardingFormView.swift
//  MusicJourney
//

import SwiftUI

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
    @StateObject private var viewModel = OnboardingViewModel()

    private var slideTransition: AnyTransition {
        let insertion = AnyTransition.move(edge: viewModel.direction > 0 ? .trailing : .leading)
            .combined(with: .opacity)
        let removal   = AnyTransition.move(edge: viewModel.direction > 0 ? .leading  : .trailing)
            .combined(with: .opacity)
        return .asymmetric(insertion: insertion, removal: removal)
    }

    var body: some View {
        ZStack {
            stepView
                .transition(slideTransition)
                .id(viewModel.currentStep)
        }
        .animation(.easeInOut(duration: 0.3), value: viewModel.currentStep)
    }

    // MARK: - Step router

    @ViewBuilder
    private var stepView: some View {
        switch viewModel.currentStep {
        case 0:
            OnboardingWelcomeStep(
                currentStep: viewModel.currentStep,
                onNext: { viewModel.advance() }
            )
        case 1:
            OnboardingLevelStep(
                currentStep: viewModel.currentStep,
                selectedLevel: $viewModel.selectedLevel,
                canAdvance: viewModel.canAdvance,
                onBack: { viewModel.goBack() },
                onNext: { viewModel.advance() }
            )
        case 2:
            OnboardingInstrumentStep(
                currentStep: viewModel.currentStep,
                selectedInstrument: $viewModel.selectedInstrument,
                canAdvance: viewModel.canAdvance,
                onBack: { viewModel.goBack() },
                onNext: { viewModel.advance() }
            )
        case 3:
            OnboardingGenreStep(
                currentStep: viewModel.currentStep,
                selectedGenres: $viewModel.selectedGenres,
                canAdvance: viewModel.canAdvance,
                onBack: { viewModel.goBack() },
                onNext: { viewModel.advance() }
            )
        case 4:
            OnboardingScheduleStep(
                currentStep: viewModel.currentStep,
                selectedSchedule: $viewModel.selectedSchedule,
                canAdvance: viewModel.canAdvance,
                onBack: { viewModel.goBack() },
                onFinish: { viewModel.finishOnboarding() }
            )
        default:
            EmptyView()
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
