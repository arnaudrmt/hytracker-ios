//
//  PlayerPetsSheet.swift
//  HyTracker
//
//  Created by Arnaud on 30/11/2025.
//

import Foundation
import SwiftUI

struct PlayerPetsSheet: View {
    @Environment(\.dismiss) var dismiss
    let memberStats: SkyblockMember
    
    var sortedPets: [Pet] {
        guard let pets = memberStats.petsData?.pets else { return [] }
            
            return pets.sorted { p1, p2 in
                if p1.active != p2.active {
                    return p1.active
                }
                
                let order1 = PetRarity.getOrder(tier: p1.tier)
                let order2 = PetRarity.getOrder(tier: p2.tier)
                
                if order1 != order2 {
                    return order1 < order2
                }
                
                return p1.exp > p2.exp
            }
    }
    
    var totalPets: Int {
        memberStats.petsData?.pets?.count ?? 0
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    
                    Text("\(totalPets) Pets")
                        .font(.caption)
                        .bold()
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color("mc_gold"))
                        .foregroundStyle(Color("mc_black"))
                        .clipShape(Capsule())
                        .shadow(color: Color("mc_black").opacity(0.1), radius: 5, x: 0, y: 2)
                    
                    if sortedPets.isEmpty {
                        Text("No pets found")
                            .foregroundStyle(Color("mc_gray"))
                            .padding(.top, 50)
                    } else {
                        ForEach(sortedPets) { pet in
                            PetRowView(pet: pet)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Pets")
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

struct PetRowView: View {
    let pet: Pet
    
    var info: SkyblockCalculator.PetInfo {
        SkyblockCalculator.calculatePetLevel(exp: pet.exp, rarity: pet.tier)
    }
    
    var petName: String {
        return pet.type.replacingOccurrences(of: "_", with: " ").capitalized
    }
    
    var petColor: Color {
        PetRarity.getColor(tier: pet.tier)
    }
    
    var body: some View {
        SkyblockProgressRow(
            title: petName,
            color: petColor,
            asset: "PET_\(pet.type)",
            levelText: "Lvl \(info.level)",
            progress: info.progress,
            progressTextLeft: pet.tier.capitalized,
            progressTextRight: pet.active ? "ACTIVE" : info.progress >= 1 ? "MAXED" :"\(Int(info.progress * 100))%"
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(pet.active ? petColor : .clear, lineWidth: 2)
        )
    }
}
