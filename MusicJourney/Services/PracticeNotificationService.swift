//
//  PracticeNotificationService.swift
//  MusicJourney
//

import Foundation
import UserNotifications

final class PracticeNotificationService: NSObject {
    static let shared = PracticeNotificationService()

    private let notificationCenter = UNUserNotificationCenter.current()
    private let reminderIdentifier = "practice-reminder-daily"
    private let testIdentifier = "practice-reminder-test"

    private override init() {
        super.init()
        notificationCenter.delegate = self
    }

    func requestAuthorization() async -> Bool {
        do {
            return try await notificationCenter.requestAuthorization(options: [.alert, .sound, .badge])
        } catch {
            print("PracticeNotificationService: erro de autorização — \(error)")
            return false
        }
    }

    func syncReminder(for schedule: PracticeSchedule) async {
        guard await requestAuthorization() else { return }
        await scheduleReminder(for: schedule)
    }

    func syncReminder(forUser user: User) async {
        let schedule = PracticeSchedule(rawValue: user.practiceSchedule ?? "") ?? .noite
        await syncReminder(for: schedule)
    }

    private func scheduleReminder(for schedule: PracticeSchedule) async {
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [reminderIdentifier])

        let content = UNMutableNotificationContent()
        content.title = "Hora de praticar!"
        content.body = "Reserve um momento para sua sessão de música hoje."
        content.sound = .default

        var dateComponents = DateComponents()
        dateComponents.hour = schedule.reminderHour
        dateComponents.minute = schedule.reminderMinute

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: reminderIdentifier, content: content, trigger: trigger)

        do {
            try await notificationCenter.add(request)
        } catch {
            print("PracticeNotificationService: erro de agendamento — \(error)")
        }
    }

    // TEMP: remover antes do release — botão de teste no perfil
    func sendTestNotification() async {
        guard await requestAuthorization() else {
            print("PracticeNotificationService: notificação de teste — permissão negada")
            return
        }

        notificationCenter.removePendingNotificationRequests(withIdentifiers: [testIdentifier])

        let content = UNMutableNotificationContent()
        content.title = "Hora de praticar!"
        content.body = "Reserve um momento para sua sessão de música hoje."
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: testIdentifier, content: content, trigger: trigger)

        do {
            try await notificationCenter.add(request)
        } catch {
            print("PracticeNotificationService: erro na notificação de teste — \(error)")
        }
    }
}

// MARK: - Foreground presentation

extension PracticeNotificationService: UNUserNotificationCenterDelegate {
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.banner, .sound, .badge])
    }
}
