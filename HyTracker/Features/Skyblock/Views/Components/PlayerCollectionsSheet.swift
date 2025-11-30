//
//  PlayerCollectionSheet.swift
//  HyTracker
//
//  Created by Arnaud on 29/11/2025.
//

import Foundation
import SwiftUI

struct PlayerCollectionsSheet: View {
    @Environment(\.dismiss) var dismiss
    
    let memberStats: SkyblockMember
    
    let listColumns = [GridItem(.flexible())]
    
    var sortedCollectionIDs: [String] {
        guard let collection = memberStats.collection else { return [] }
        return Array(collection.keys).sorted()
    }
    
    var grouppedCollections: [CollectionSectionData] {
        let manager = SkyblockResourceManager.shared
        guard let userCollection = memberStats.collection else { return [] }
        
        var sections: [CollectionSectionData] = []
        
        for catKey in manager.categoryOrder {
            if let category = manager.categories[catKey] {
                let activeItems = category.items.keys.filter { itemID in
                    return (userCollection[itemID] ?? 0) > 0
                }
                
                if !activeItems.isEmpty {
                    let sortedItems = activeItems.sorted {
                        (userCollection[$0] ?? 0) > (userCollection[$1] ?? 0)
                    }
                    sections.append(CollectionSectionData(title: category.name, items: sortedItems))
                }
            }
        }
        return sections
    }
    
    var collectionProgress: (maxed: Int, total: Int) {
        let allCollectionIDs = SkyblockResourceManager.shared.collectionDefinitions.keys
        
        let maxedCount = allCollectionIDs.filter { id in
            let amount = memberStats.collection?[id] ?? 0
            
            return SkyblockCalculator.calculateCollectionDynamic(id: id, amount: amount).isMaxed
        }.count
        
        return (maxedCount, allCollectionIDs.count)
    }
        
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 25) {
                    
                    Text("\(collectionProgress.maxed)/\(collectionProgress.total) Maxed")
                        .font(.caption)
                        .bold()
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color("mc_gold"))
                        .foregroundStyle(Color("mc_black"))
                        .clipShape(Capsule())
                        .shadow(color: Color("mc_black").opacity(0.1), radius: 5, x: 0, y: 2)
                    
                    ForEach(grouppedCollections) { section in
                        
                        let style = SkyblockStyle.getCollectionSectionStyle(name: section.title)
                        
                        StatSectionView(title: section.title, icon: style.icon, color: style.color, columns: listColumns) {
                            
                            ForEach(section.items, id: \.self) { itemID in
                                CollectionItemView(
                                    itemID: itemID,
                                    memberStats: memberStats,
                                    color: style.color
                                )
                            }
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
}

struct CollectionItemView: View {
    let itemID: String
    let memberStats: SkyblockMember
    let color: Color
    
    var body: some View {
        
        let amount = memberStats.collection?[itemID] ?? 0
        let info = SkyblockCalculator.calculateCollectionDynamic(id: itemID, amount: amount)
        let niceName = SkyblockResourceManager.shared.collectionDefinitions[itemID]?.name ?? itemID
        
        SkyblockProgressRow(
            title: niceName,
            color: color,
            asset: "\(itemID)",
            levelText: "Tier \(info.tierRoman)",
            progress: info.progress,
            progressTextLeft: "\(amount.abbreviated()) / \(info.goal.abbreviated())",
            progressTextRight: info.isMaxed ? "MAXED" : "\(Int(info.progress * 100))%"
        )
    }
}

struct CollectionSectionData: Identifiable {
    let id = UUID()
    let title: String
    let items: [String]
}
