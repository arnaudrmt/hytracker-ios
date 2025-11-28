//
//  PlayerSkillsSheet.swift
//  HyTracker
//
//  Created by Arnaud on 28/11/2025.
//

import Foundation
import SwiftUI

struct PlayerSkillsSheet: View {
    @Environment(\.dismiss) var dismiss
    
    let playerData: HypixelAPI.PlayerData

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    
                    SkillRowView(type: .combat, xp: playerData.combatXP ?? 0)
                    SkillRowView(type: .mining, xp: playerData.miningXP ?? 0)
                    SkillRowView(type: .farming, xp: playerData.farmingXP ?? 0)
                    SkillRowView(type: .foraging, xp: playerData.foragingXP ?? 0)
                    SkillRowView(type: .fishing, xp: playerData.fishingXP ?? 0)
                    SkillRowView(type: .enchanting, xp: playerData.enchantingXP ?? 0)
                    SkillRowView(type: .alchemy, xp: playerData.alchemyXP ?? 0)
                    SkillRowView(type: .taming, xp: playerData.tamingXP ?? 0)
                    SkillRowView(type: .runecrafting, xp: playerData.runecraftingXP ?? 0)
                    SkillRowView(type: .social, xp: playerData.socialXP ?? 0)
                    SkillRowView(type: .carpentry, xp: playerData.carpentryXP ?? 0)
                }
                .padding()
            }
            .navigationTitle("Skills")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("OK") { dismiss() }
                }
            }
            .background(Color(.systemGroupedBackground))
        }
    }
}
