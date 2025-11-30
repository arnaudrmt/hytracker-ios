//
//  RessourceModels.swift
//  HyTracker
//
//  Created by Arnaud on 29/11/2025.
//

import Foundation

// --- Skyblock Collections ---

struct CollectionsReponse: Decodable {
    let success: Bool
    let collections: [String: CollectionCategory]
}

struct CollectionCategory: Decodable {
    let name: String
    let items: [String: CollectionItem]
}

struct CollectionItem: Decodable {
    let name: String
    let maxTiers: Int
    let tiers: [CollectionTier]
}

struct CollectionTier: Decodable {
    let tier: Int
    let amountRequired: Int
    let unlocks: [String]?
}

// --- Skyblock Skills ---

struct SkillsResponse: Decodable {
    let success: Bool
    let skills: [String: SkillDefinition]
}

struct SkillDefinition: Decodable {
    let name: String
    let description: String?
    let maxLevel: Int
    let levels: [SkillLevelDefinition]
}

struct SkillLevelDefinition: Decodable {
    let level: Int
    let totalExpRequired: Double
    let unlocks: [String]?
}
