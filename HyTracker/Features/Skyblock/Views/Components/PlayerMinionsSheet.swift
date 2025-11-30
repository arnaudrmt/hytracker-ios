//
//  PlayerMinionsSheet.swift
//  HyTracker
//
//  Created by Arnaud on 29/11/2025.
//

import Foundation
import SwiftUI

struct PlayerMinionsSheet: View {
    @Environment(\.dismiss) var dismiss
    
    let memberStats: SkyblockMember
    
    var minions: [SkyblockCalculator.MinionInfo] {
        SkyblockCalculator.parseMinions(craftedList: memberStats.playerData?.craftedGenerators)
    }
    
    var uniqueCrafts: Int {
        memberStats.playerData?.craftedGenerators?.count ?? 0
    }
    
    var groupedMinions: [CollectionSectionData] {
        
        let order = ["FARMING", "MINING", "COMBAT", "FORAGING", "FISHING", "MISC"]
        var tempGrouping: [String: [SkyblockCalculator.MinionInfo]] = [:]
        
        for minion in minions {
            let category = MinionData.getCategory(for: minion.rawID)
            
            tempGrouping[category, default: []].append(minion)
        }
        
        var sections: [CollectionSectionData] = []
        
        for categoryName in order {
            if let minionsInCat = tempGrouping[categoryName], !minionsInCat.isEmpty {
                let ids = minionsInCat.map { $0.rawID }
                sections.append(CollectionSectionData(title: categoryName, items: ids))
            }
        }
        
        return sections
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 12) {
                    
                    Text("\(uniqueCrafts) Uniques")
                        .font(.caption)
                        .bold()
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color("mc_gold"))
                        .foregroundStyle(Color("mc_black"))
                        .clipShape(Capsule())
                        .shadow(color: Color("mc_black").opacity(0.1), radius: 5, x: 0, y: 2)
                    
                    ForEach(groupedMinions) { section in
                        
                        let style = SkyblockStyle.getCollectionSectionStyle(name: section.title)
                        
                        StatSectionView(
                            title: section.title,
                            icon: style.icon,
                            color: style.color,
                            columns: [GridItem(.flexible())]
                        ) {
                            VStack(spacing: 24) {
                                ForEach(section.items, id: \.self) { minionID in
                                    if let info = minions.first(where: { $0.rawID == minionID }) {
                                        SkyblockProgressRow(
                                            title: info.name,
                                            color: style.color,
                                            asset: "\(info.rawID)_GENERATOR_1",
                                            levelText: "Tier \(SkyblockCalculator.toRoman(info.maxTierCrafted))",
                                            progress: info.progress,
                                            progressTextLeft: "Tier \(info.maxTierCrafted) / \(info.totalTiers)",
                                            progressTextRight: info.isMaxed ? "MAXED" : ""
                                        )
                                    }
                                }
                            }
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Crafted Minions")
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
