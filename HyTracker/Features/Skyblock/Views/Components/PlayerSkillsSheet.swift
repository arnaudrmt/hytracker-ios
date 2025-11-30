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
    
    let memberStats: SkyblockMember
    
    var sortedSkills: [String] {
        let allSkills = SkyblockResourceManager.shared.skillDefinitions.keys
        return allSkills.sorted()
    }
    
    var skillProgress: (maxed: Int, total: Int) {
        let allSkillIDs = SkyblockResourceManager.shared.skillDefinitions.keys
        
        let maxedCount = allSkillIDs.filter { id in
            let key = "SKILL_\(id)"
            let xp = memberStats.playerData?.experience?[key] ?? 0
            
            return SkyblockCalculator.calculateSkillDynamic(skillID: id, xp: xp).isMaxed
        }.count
        
        return (maxedCount, allSkillIDs.count)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    
                    Text("\(skillProgress.maxed)/\(skillProgress.total) Maxed")
                            .font(.caption)
                            .bold()
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color("mc_gold"))
                            .foregroundStyle(Color("mc_black"))
                            .clipShape(Capsule())
                            .shadow(color: Color("mc_black").opacity(0.1), radius: 5, x: 0, y: 2)
                    
                    ForEach(sortedSkills, id: \.self) { skillID in
                        
                        if let def = SkyblockResourceManager.shared.skillDefinitions[skillID] {
                            
                            SkillRowView(
                                skillID: skillID,
                                skillName: def.name,
                                xp: getXP(for: skillID)
                            )
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Collections")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button { dismiss() } label: { Image(systemName: "xmark") }
                }
            }
            .background(Color(.systemGroupedBackground))
        }
    }
    
    func getXP(for skillID: String) -> Double {
        let key = "SKILL_\(skillID)"
        return memberStats.playerData?.experience?[key] ?? 0
    }
}

struct SkillRowView: View {
    
    let skillID: String
    let skillName: String
    let xp: Double
    
    var theme: SkillTheme {
        SkyblockStyle.getSkillTheme(id: skillID)
    }
    
    var info: SkyblockCalculator.SkillInfo {
        SkyblockCalculator.calculateSkillDynamic(skillID: skillID, xp: xp)
    }
    
    var body: some View {
        SkyblockProgressRow(
            title: skillName,
            color: theme.color,
            asset: theme.asset,
            levelText: "Lvl \(info.level)",
            progress: info.progress,
            progressTextLeft: "\(info.currentXP.abbreviated()) / \(info.goalXP.abbreviated()) XP",
            progressTextRight: info.isMaxed ? "MAXED" : "\(Int(info.progress * 100))%"
        )
    }
}
