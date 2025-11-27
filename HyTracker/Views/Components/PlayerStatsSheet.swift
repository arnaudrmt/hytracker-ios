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
                    
                    VStack(spacing: 5) {
                        Text("Stats Naturelles")
                            .font(.headline)
                        Text("(Base + Skills + Fairy Souls)")
                            .font(.caption)
                            .foregroundStyle(.gray)
                    }
                    .padding(.top, 10)
                    .padding(.bottom, 5)
                    
                    StatSectionView(title: "Survivability", icon: "heart.fill", color: .skyblockRed) {
                        StatBoxView(icon: .health, name: "Health", value: stats.fmt(stats.health), color: .skyblockRed)
                        StatBoxView(icon: .defense, name: "Defense", value: stats.fmt(stats.defense), color: .skyblockGreen)
                        StatBoxView(icon: .healthRegen, name: "Regen", value: stats.fmt(stats.healthRegen), color: .skyblockRed)
                        StatBoxView(icon: .vitality, name: "Vitality", value: stats.fmt(stats.vitality), color: .skyblockPurple)
                        StatBoxView(icon: .mending, name: "Mending", value: stats.fmt(stats.mending), color: .skyblockGreen)
                    }
                    
                    StatSectionView(title: "Combat", icon: "flame.fill", color: .skyblockGold) {
                        StatBoxView(icon: .strength, name: "Strength", value: stats.fmt(stats.strength), color: .skyblockRed)
                        StatBoxView(icon: .critChance, name: "Crit Ch", value: "\(stats.fmt(stats.critChance))%", color: .skyblockDarkBlue)
                        StatBoxView(icon: .critDamage, name: "Crit Dmg", value: "\(stats.fmt(stats.critDamage))%", color: .skyblockDarkBlue)
                        StatBoxView(icon: .bonusAttackSpeed, name: "Atk Spd", value: "\(stats.fmt(stats.attackSpeed))%", color: .skyblockYellow)
                        StatBoxView(icon: .ferocity, name: "Ferocity", value: stats.fmt(stats.ferocity), color: .skyblockRed)
                        StatBoxView(icon: .fear, name: "Fear", value: stats.fmt(stats.fear), color: .skyblockPurple)
                    }
                    
                    StatSectionView(title: "Misc & Magic", icon: "sparkles", color: .skyblockAqua) {
                        StatBoxView(icon: .intelligence, name: "Intel", value: stats.fmt(stats.intelligence), color: .skyblockBlue)
                        StatBoxView(icon: .abilityDamage, name: "Ability Dmg", value: "\(stats.fmt(stats.abilityDamage))%", color: .skyblockRed)
                        StatBoxView(icon: .speed, name: "Speed", value: stats.fmt(stats.speed), color: .primary)
                        StatBoxView(icon: .magicFind, name: "Magic Find", value: stats.fmt(stats.magicFind), color: .skyblockBlue)
                        StatBoxView(icon: .petLuck, name: "Pet Luck", value: stats.fmt(stats.petLuck), color: .skyblockPink)
                    }
                    
                    StatSectionView(title: "Gathering", icon: "leaf.fill", color: .skyblockGreen) {
                        StatBoxView(icon: .farmingFortune, name: "Farm Ft", value: stats.fmt(stats.farmingFortune), color: .skyblockGold)
                        StatBoxView(icon: .miningFortune, name: "Mine Ft", value: stats.fmt(stats.miningFortune), color: .skyblockGold)
                        StatBoxView(icon: .miningSpeed, name: "Mine Spd", value: stats.fmt(stats.miningSpeed), color: .skyblockGold)
                        StatBoxView(icon: .foragingFortune, name: "Forage Ft", value: stats.fmt(stats.foragingFortune), color: .skyblockGold)
                        StatBoxView(icon: .gemstoneFortune, name: "Gem Ft", value: stats.fmt(stats.gemstoneFortune), color: .skyblockGold)
                        StatBoxView(icon: .fishingSpeed, name: "Fish Spd", value: stats.fmt(stats.fishingSpeed), color: .skyblockBlue)
                        StatBoxView(icon: .seaCreatureChance, name: "SC Chance", value: "\(stats.fmt(stats.seaCreatureChance))%", color: .skyblockAqua)
                    }
                }
                .padding()
            }
            .navigationTitle("Statistiques")
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
