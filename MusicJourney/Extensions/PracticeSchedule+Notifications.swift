//
//  PracticeSchedule+Notifications.swift
//  MusicJourney
//

import Foundation

extension PracticeSchedule {
    var reminderHour: Int {
        switch self {
        case .manha: return 8
        case .tarde: return 14
        case .noite: return 20
        }
    }

    var reminderMinute: Int { 0 }

    var reminderWindowLabel: String {
        switch self {
        case .manha: return "06:00–11:00"
        case .tarde: return "12:00–17:00"
        case .noite: return "18:00–22:00"
        }
    }

    var reminderTimeLabel: String {
        String(format: "%02d:%02d", reminderHour, reminderMinute)
    }

    var reminderSummaryLabel: String {
        "Lembrete diário às \(reminderTimeLabel) (\(rawValue), \(reminderWindowLabel))"
    }
}
