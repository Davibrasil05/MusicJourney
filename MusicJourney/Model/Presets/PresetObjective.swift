//
//  PresetObjective.swift
//  MusicJourney
//
//  Created by academy on 10/06/26.
//

import Foundation

// MARK: - Structs em memória (não CoreData) para objetivos pré-definidos

struct PresetObjective: Identifiable {
    let id = UUID()
    let instrument: String      // Ex: "Violão"
    let level: String           // Ex: "Iniciante"
    let name: String            // Ex: "Tocar 'Knockin' On Heaven's Door'"
    let descriptionText: String
    let goals: [PresetGoal]
}

struct PresetGoal: Identifiable {
    let id = UUID()
    let name: String
    let textDescription: String
    let category: String        // Ex: "Repertório", "Técnica"
    let difficulty: String      // Ex: "Fácil", "Médio", "Difícil"
    let type: String            // "practice", "milestone"
    let order: Int16            // Posição na trilha (1, 2, 3...)
    let isFinal: Bool           // true apenas na última meta
    let xpReward: Int32
}
