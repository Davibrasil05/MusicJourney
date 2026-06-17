import Foundation
import CoreData

class UserRepository: ObservableObject {
    let context = PersistenceController.shared.container.viewContext

    @Published var currentUser: User?

    init() { fetchUser() }

    // MARK: - Fetch

    func fetchUser() {
        let request = NSFetchRequest<User>(entityName: "User")
        request.fetchLimit = 1
        do {
            currentUser = try context.fetch(request).first
        } catch {
            print("UserRepository: fetch error — \(error)")
        }
    }

    // MARK: - Create (called once at end of onboarding)

    @discardableResult
    func createUser(
        instrument: String,
        experienceLevel: String,
        levelValue: Int16,
        genres: [String],
        practiceSchedule: String
    ) -> User {
        let user = User(context: context)
        user.id = UUID()
        user.name = ""
        user.instrument = instrument
        user.experienceLevel = experienceLevel
        user.level = levelValue
        user.genres = genres as NSArray
        user.practiceSchedule = practiceSchedule
        user.xp = 0
        user.streak = 0
        save()
        fetchUser()
        return user
    }

    // MARK: - XP & Streak

    func gainXP(amount: Int16) {
        guard let user = currentUser else { return }
        user.xp += amount
        if user.xp >= 100 {
            user.level += 1
            user.xp = 0
        }
        save()
    }

    func incrementStreak() {
        guard let user = currentUser else { return }
        user.streak += 1
        save()
    }

    // MARK: - Save

    func save() {
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch {
            print("UserRepository: save error — \(error)")
        }
    }

    // MARK: - AI Profile Snapshot

    /// Returns the fields GeminiService.generateGoals needs from User.
    func aiProfileSnapshot(from user: User) -> (instrument: String, experienceLevel: String, genresJoined: String) {
        let instrument = user.instrument ?? ""
        let level = user.experienceLevel ?? ""
        let genres = (user.genres as? [String] ?? []).joined(separator: ", ")
        return (instrument, level, genres)
    }
}
