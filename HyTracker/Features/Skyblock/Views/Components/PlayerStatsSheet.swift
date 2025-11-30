//
//  PlayerStatsSheet.swift
//  HyTracker
//
//  Created by Arnaud on 27/11/2025.
//

import Foundation
import SwiftUI

struct PlayerStatsSheet: View {
    @Environment(\.dismiss) var dismiss
    
    let stats: SkyblockCalculator.CalculatedStats
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    
                    // --- Survival Stats ---
                    
                    StatSectionView(title: "Survival", icon: "heart.fill", color: Color("mc_red")) {
                        StatBoxView(icon: .health, name: "Health", value: stats.fmt(stats.health), color:  Color("mc_red"))
                        StatBoxView(icon: .defense, name: "Defense", value: stats.fmt(stats.defense), color:  Color("mc_dark_green"))
                        StatBoxView(icon: .healthRegen, name: "Regen", value: stats.fmt(stats.healthRegen), color: Color("mc_red"))
                        StatBoxView(icon: .vitality, name: "Vitality", value: stats.fmt(stats.vitality), color:  Color("mc_dark_purple"))
                        StatBoxView(icon: .mending, name: "Mending", value: stats.fmt(stats.mending), color:  Color("mc_dark_green"))
                    }
                    
                    // --- Combat Stats ---
                    
                    StatSectionView(title: "Combat", icon: "flame.fill", color: Color("mc_gold")) {
                        StatBoxView(icon: .strength, name: "Strength", value: stats.fmt(stats.strength), color: Color("mc_red"))
                        StatBoxView(icon: .critChance, name: "Crit Ch", value: "\(stats.fmt(stats.critChance))%", color:  Color("mc_dark_blue"))
                        StatBoxView(icon: .critDamage, name: "Crit Dmg", value: "\(stats.fmt(stats.critDamage))%", color:  Color("mc_dark_blue"))
                        StatBoxView(icon: .bonusAttackSpeed, name: "Atk Spd", value: "\(stats.fmt(stats.bonusAttackSpeed))%", color:  Color("mc_yellow"))
                        StatBoxView(icon: .ferocity, name: "Ferocity", value: stats.fmt(stats.ferocity), color:  Color("mc_red"))
                        StatBoxView(icon: .fear, name: "Fear", value: stats.fmt(stats.fear), color:  Color("mc_dark_purple"))
                    }
                    
                    // --- Magic Stats ---
                    
                    StatSectionView(title: "Misc & Magic", icon: "sparkles", color:  Color("mc_dark_aqua")) {
                        StatBoxView(icon: .intelligence, name: "Intel", value: stats.fmt(stats.intelligence), color:  Color("mc_blue"))
                        StatBoxView(icon: .abilityDamage, name: "Ability Dmg", value: "\(stats.fmt(stats.abilityDamage))%", color:  Color("mc_red"))
                        StatBoxView(icon: .speed, name: "Speed", value: stats.fmt(stats.speed), color: Color("mc_primary"))
                        StatBoxView(icon: .magicFind, name: "Magic Find", value: stats.fmt(stats.magicFind), color:  Color("mc_blue"))
                        StatBoxView(icon: .petLuck, name: "Pet Luck", value: stats.fmt(stats.petLuck), color:  Color("mc_light_purple"))
                    }
                    
                    // --- Gathering Stats ---
                    
                    StatSectionView(title: "Gathering", icon: "leaf.fill", color:  Color("mc_dark_green")) {
                        StatBoxView(icon: .farmingFortune, name: "Farm Ft", value: stats.fmt(stats.farmingFortune), color:  Color("mc_gold"))
                        StatBoxView(icon: .miningFortune, name: "Mine Ft", value: stats.fmt(stats.miningFortune), color:  Color("mc_gold"))
                        StatBoxView(icon: .miningSpeed, name: "Mine Spd", value: stats.fmt(stats.miningSpeed), color:  Color("mc_gold"))
                        StatBoxView(icon: .foragingFortune, name: "Forage Ft", value: stats.fmt(stats.foragingFortune), color:  Color("mc_gold"))
                        StatBoxView(icon: .gemstoneFortune, name: "Gem Ft", value: stats.fmt(stats.gemstoneFortune), color:  Color("mc_gold"))
                        StatBoxView(icon: .fishingSpeed, name: "Fish Spd", value: stats.fmt(stats.fishingSpeed), color:  Color("mc_blue"))
                        StatBoxView(icon: .seaCreatureChance, name: "SC Chance", value: "\(stats.fmt(stats.seaCreatureChance))%", color:  Color("mc_dark_aqua"))
                    }
                }
                .padding()
            }
            .navigationTitle("Stats")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button { dismiss() } label: { Image(systemName: "xmark") }
                }
            }
            .background(Color(.systemGroupedBackground))
        }
    }
}
