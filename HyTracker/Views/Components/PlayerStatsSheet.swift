//
//  PlayerStatsSheet.swift
//  HyTracker
//
//  Created by Arnaud on 27/11/2025.
//

import Foundation
import SwiftUI

struct PlayerStatsSheet: View {
    let stats: SkyblockCalculator.CalculatedStats
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    
                    StatSectionView(title: "Survivability", icon: "heart.fill", color: .skyblockColorRed) {
                        StatBoxView(icon: .health, name: "Health", value: stats.fmt(stats.health), color: .skyblockColorRed)
                        StatBoxView(icon: .defense, name: "Defense", value: stats.fmt(stats.defense), color: .skyblockColorGreen)
                        StatBoxView(icon: .healthRegen, name: "Regen", value: stats.fmt(stats.healthRegen), color: .skyblockColorRed)
                        StatBoxView(icon: .vitality, name: "Vitality", value: stats.fmt(stats.vitality), color: .skyblockColorPurple)
                        StatBoxView(icon: .mending, name: "Mending", value: stats.fmt(stats.mending), color: .skyblockColorGreen)
                    }
                    
                    StatSectionView(title: "Combat", icon: "flame.fill", color: .skyblockColorGold) {
                        StatBoxView(icon: .strength, name: "Strength", value: stats.fmt(stats.strength), color: .skyblockColorRed)
                        StatBoxView(icon: .critChance, name: "Crit Ch", value: "\(stats.fmt(stats.critChance))%", color: .skyblockColorDarkBlue)
                        StatBoxView(icon: .critDamage, name: "Crit Dmg", value: "\(stats.fmt(stats.critDamage))%", color: .skyblockColorDarkBlue)
                        StatBoxView(icon: .bonusAttackSpeed, name: "Atk Spd", value: "\(stats.fmt(stats.attackSpeed))%", color: .skyblockColorYellow)
                        StatBoxView(icon: .ferocity, name: "Ferocity", value: stats.fmt(stats.ferocity), color: .skyblockColorRed)
                        StatBoxView(icon: .fear, name: "Fear", value: stats.fmt(stats.fear), color: .skyblockColorPurple)
                    }
                    
                    StatSectionView(title: "Misc & Magic", icon: "sparkles", color: .skyblockColorAqua) {
                        StatBoxView(icon: .intelligence, name: "Intel", value: stats.fmt(stats.intelligence), color: .skyblockColorBlue)
                        StatBoxView(icon: .abilityDamage, name: "Ability Dmg", value: "\(stats.fmt(stats.abilityDamage))%", color: .skyblockColorRed)
                        StatBoxView(icon: .speed, name: "Speed", value: stats.fmt(stats.speed), color: .primary)
                        StatBoxView(icon: .magicFind, name: "Magic Find", value: stats.fmt(stats.magicFind), color: .skyblockColorBlue)
                        StatBoxView(icon: .petLuck, name: "Pet Luck", value: stats.fmt(stats.petLuck), color: .skyblockColorPink)
                    }
                    
                    StatSectionView(title: "Gathering", icon: "leaf.fill", color: .skyblockColorGreen) {
                        StatBoxView(icon: .farmingFortune, name: "Farm Ft", value: stats.fmt(stats.farmingFortune), color: .skyblockColorGold)
                        StatBoxView(icon: .miningFortune, name: "Mine Ft", value: stats.fmt(stats.miningFortune), color: .skyblockColorGold)
                        StatBoxView(icon: .miningSpeed, name: "Mine Spd", value: stats.fmt(stats.miningSpeed), color: .skyblockColorGold)
                        StatBoxView(icon: .foragingFortune, name: "Forage Ft", value: stats.fmt(stats.foragingFortune), color: .skyblockColorGold)
                        StatBoxView(icon: .gemstoneFortune, name: "Gem Ft", value: stats.fmt(stats.gemstoneFortune), color: .skyblockColorGold)
                        StatBoxView(icon: .fishingSpeed, name: "Fish Spd", value: stats.fmt(stats.fishingSpeed), color: .skyblockColorBlue)
                        StatBoxView(icon: .seaCreatureChance, name: "SC Chance", value: "\(stats.fmt(stats.seaCreatureChance))%", color: .skyblockColorAqua)
                    }
                }
                .padding()
            }
            .navigationTitle("Statistics")
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
