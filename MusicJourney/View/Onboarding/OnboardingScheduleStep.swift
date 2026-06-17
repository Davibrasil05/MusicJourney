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
        .onAppear {
            if selectedSchedule == nil {
                selectedSchedule = .manha
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
                VStack(spacing: 24) {
                    Text("Qual horário você\nprefere praticar?")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(Color("textDark"))
                        .multilineTextAlignment(.center)
                        .padding(.top, 56)

                    VStack(spacing: 20) {
                        ForEach(PracticeSchedule.allCases) { schedule in
                            scheduleRow(schedule)
                        }
                    }
                    .padding(.bottom, 8)
                }
                .padding(.horizontal, 15)
            }

            OnboardingPrimaryButton(
                title: "Finalizar",
                isEnabled: canAdvance,
                action: onFinish
            )
            .padding(.horizontal, 16)
            .padding(.bottom, 81)
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
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(isSelected ? Color("cardCream").opacity(0.2) : Color("inputGray"))
                        .frame(width: 100, height: 100)

                    Image(schedule.assetName)
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 36, height: 36)
                        .foregroundColor(isSelected ? Color("cardCream") : Color.white)
                }

                Text(schedule.rawValue)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(isSelected ? Color("cardCream") : Color("textDark"))

                Spacer()
            }
            .frame(width: 363, height: 100)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(isSelected ? Color("headerGreen") : Color("backgroundCards"))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(isSelected ? Color("headerGreen") : Color("inputGray"), lineWidth: 1.5)
                    )
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
