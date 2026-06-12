//
//  OnboardingScheduleStep.swift
//  MusicJourney
//

import SwiftUI

struct OnboardingScheduleStep: View {
    let currentStep: Int
    @Binding var selectedSchedule: PracticeSchedule?
    let canAdvance: Bool
    let onBack: () -> Void
    let onFinish: () -> Void

    var body: some View {
        ZStack(alignment: .top) {
            Color("headerGreen").ignoresSafeArea()

            VStack(spacing: 0) {
                headerSection
                cardSection
            }
        }
    }

    // MARK: - Header

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            backButton

            VStack(spacing: 10) {
                OnboardingDotsIndicator(currentStep: currentStep, totalSteps: 5, onColoredBackground: true)

                Text("Horário de praticar")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity)
        }
        .padding(.horizontal, 24)
        .padding(.top, 20)
        .padding(.bottom, 40)
    }

    private var backButton: some View {
        Button(action: onBack) {
            HStack(spacing: 4) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 14, weight: .semibold))
                Text("Voltar")
                    .font(.system(size: 16))
            }
            .foregroundColor(Color("cardCream"))
        }
        .buttonStyle(PlainButtonStyle())
    }

    // MARK: - Card

    private var cardSection: some View {
        VStack(spacing: 0) {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {
                    Text("Qual horário você\nprefere praticar?")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(Color("textDark"))
                        .multilineTextAlignment(.center)
                        .padding(.top, 28)

                    VStack(spacing: 12) {
                        ForEach(PracticeSchedule.allCases) { schedule in
                            scheduleRow(schedule)
                        }
                    }
                    .padding(.bottom, 8)
                }
                .padding(.horizontal, 24)
            }

            OnboardingPrimaryButton(
                title: "Finalizar",
                isEnabled: canAdvance,
                action: onFinish
            )
            .padding(.horizontal, 24)
            .padding(.bottom, 36)
            .padding(.top, 8)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("cardCream"))
        .clipShape(RoundedCorner(radius: 40, corners: [.topLeft, .topRight]))
        .ignoresSafeArea(edges: .bottom)
    }

    // MARK: - Schedule row

    private func scheduleRow(_ schedule: PracticeSchedule) -> some View {
        let isSelected = selectedSchedule == schedule

        return Button(action: { selectedSchedule = schedule }) {
            HStack(spacing: 16) {
                Image(schedule.assetName)
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 36, height: 36)
                    .foregroundColor(isSelected ? Color("cardCream") : Color("textDark").opacity(0.35))
                    .padding(12)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(isSelected ? Color("cardCream").opacity(0.2) : Color.clear)
                    )

                Text(schedule.rawValue)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(isSelected ? Color("cardCream") : Color("textDark"))

                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(isSelected ? Color("headerGreen") : Color("backgroundCards"))
            )
        }
        .buttonStyle(PlainButtonStyle())
        .animation(.easeInOut(duration: 0.15), value: isSelected)
    }
}

// MARK: - Preview

struct OnboardingScheduleStep_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingScheduleStep(
            currentStep: 4,
            selectedSchedule: .constant(.manha),
            canAdvance: true,
            onBack: {},
            onFinish: {}
        )
        .previewDisplayName("OnboardingScheduleStep")
    }
}
