import Foundation

class OnboardingViewModel: ObservableObject {

    // MARK: - Navigation state

    @Published var currentStep: Int = 0
    @Published var direction: Int = 1

    // MARK: - Selection state

    @Published var selectedLevel: MusicLevel?
    @Published var selectedInstrument: MusicInstrument?
    @Published var selectedGenres: Set<MusicGenre> = []
    @Published var selectedSchedule: PracticeSchedule?

    // MARK: - Dependencies

    private let userRepository: UserRepository

    init(userRepository: UserRepository = UserRepository()) {
        self.userRepository = userRepository
    }

    // MARK: - Navigation

    var canAdvance: Bool {
        switch currentStep {
        case 0: return true
        case 1: return selectedLevel != nil
        case 2: return selectedInstrument != nil
        case 3: return !selectedGenres.isEmpty
        case 4: return selectedSchedule != nil
        default: return false
        }
    }

    func advance() {
        direction = 1
        currentStep += 1
    }

    func goBack() {
        direction = -1
        currentStep -= 1
    }

    // MARK: - Persist

    /// Saves the User to Core Data. Returns true on success.
    @discardableResult
    func finishOnboarding() -> Bool {
        guard let level = selectedLevel, let instrument = selectedInstrument else { return false }

        userRepository.createUser(
            instrument: instrument.rawValue,
            experienceLevel: level.rawValue,
            levelValue: level.levelValue,
            genres: selectedGenres.map(\.rawValue),
            practiceSchedule: selectedSchedule?.rawValue ?? ""
        )
        return true
    }
}
