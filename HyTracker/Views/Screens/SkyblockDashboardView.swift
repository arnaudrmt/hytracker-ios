//
//  SkyblockDashboardView.swift
//  HyTracker
//
//  Created by Arnaud on 26/11/2025.
//

import Foundation
import SwiftUI

struct SkyblockDashboardView: View {
    
    let profile: HypixelAPI.SkyblockProfile
    let playerUUID: String
    
    @Environment(\.dismiss) var dismiss
    
    @State private var isSkillsExpanded: Bool = false
    
    var memberStats: HypixelAPI.SkyblockMember? {
        let cleanUUID = playerUUID.lowercased().replacingOccurrences(of: "-", with: "")
        return profile.members?[cleanUUID]
    }

    var playerData: HypixelAPI.PlayerData? { memberStats?.playerData }
    
    var skillAverage: Double {
        let skills = [
            playerData?.combatXP, playerData?.miningXP, playerData?.farmingXP,
            playerData?.foragingXP, playerData?.fishingXP, playerData?.enchantingXP,
            playerData?.alchemyXP, playerData?.tamingXP
        ]
        return SkyblockCalculator.calculateSkillAverage(skills: skills)
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 25) {
                    
                    ProfileHeaderView(
                        profileName: profile.cuteName,
                        sbLevelXP: memberStats?.leveling?.experience ?? 0,
                        fairySouls: memberStats?.fairySoul?.totalCollected ?? 0,
                        purse: (memberStats?.currencies?.coinPurse ?? 0) + (profile.banking?.balance ?? 0),
                        skillAvg: skillAverage,
                        joinedDate: memberStats?.profileData?.firstJoin
                    )
                    .padding(.horizontal)
                    .padding(.top)
                    
                    VStack(spacing: 0) {
                        Button {
                           isSkillsExpanded.toggle()
                        } label: {
                            HStack {
                                Text("Skills")
                                    .font(.headline)
                                    .foregroundStyle(.primary)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundStyle(.gray)
                                    .rotationEffect(.degrees(isSkillsExpanded ? 90 : 0))
                            }
                            .padding()
                            .background(Color(.secondarySystemGroupedBackground))
                        }
                        
                        if isSkillsExpanded {
                            VStack(spacing: 12) {
                                Divider()
                                
                                Group {
                                    SkillRowView(type: .combat, xp: playerData?.combatXP ?? 0)
                                    SkillRowView(type: .mining, xp: playerData?.miningXP ?? 0)
                                    SkillRowView(type: .farming, xp: playerData?.farmingXP ?? 0)
                                    SkillRowView(type: .foraging, xp: playerData?.foragingXP ?? 0)
                                    SkillRowView(type: .fishing, xp: playerData?.fishingXP ?? 0)
                                    SkillRowView(type: .enchanting, xp: playerData?.enchantingXP ?? 0)
                                    SkillRowView(type: .alchemy, xp: playerData?.alchemyXP ?? 0)
                                    SkillRowView(type: .taming, xp: playerData?.tamingXP ?? 0)
                                    SkillRowView(type: .runecrafting, xp: playerData?.runecraftingXP ?? 0)
                                    SkillRowView(type: .social, xp: playerData?.socialXP ?? 0)
                                    SkillRowView(type: .carpentry, xp: playerData?.carpentryXP ?? 0)
                                }
                            }
                            .padding()
                            .background(Color(.secondarySystemGroupedBackground))
                            .transition(.opacity.combined(with: .move(edge: .top)))
                        }
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
                    .padding(.horizontal)
                    .animation(.easeInOut(duration: 0.3), value: isSkillsExpanded)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Modules")
                            .font(.headline)
                            .foregroundStyle(.secondary)
                            .padding(.leading)
                        
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 15) {
                            ModuleButton(type: .catacombs)
                            ModuleButton(type: .slayer)
                            ModuleButton(type: .inventory)
                        }
                    }
                    .padding(.horizontal)
                    
                    Spacer(minLength: 50)
                }
            }
            .background(
                ZStack {
                    LinearGradient(
                        colors: [Color.blue.opacity(0.15), Color(.systemGroupedBackground)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .ignoresSafeArea()
                }
            )
            .toolbarBackground(.hidden, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Fermer") { dismiss() }
                        .foregroundStyle(.blue)
                        .fontWeight(.bold)
                }
            }
        }
    }
}

struct SkillCard: View {
    let type: SkyblockModuleType
    let xp: Double?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: type.iconName)
                    .font(.title2)
                    .foregroundStyle(.white)
                    .frame(width: 40, height: 40)
                    .background(type.color)
                    .clipShape(Circle())
                    .shadow(color: type.color.opacity(0.5), radius: 5)
                
                Spacer()
                
                Text(type.title)
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundStyle(.white.opacity(0.6))
            }
            
            Text(xp != nil ? "\(xp!.abbreviated()) XP" : "0 XP")
                .font(.headline)
                .bold()
                .foregroundStyle(.white)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(16)
    }
}

struct StatBar: View {
    let label: String
    let value: String
    let color: Color
    let icon: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(color)
                .frame(width: 20)
                
            Text(label.uppercased())
                .font(.caption)
                .bold()
                .foregroundStyle(.white.opacity(0.7))
            
            Spacer()
            
            Text(value)
                .font(.headline)
                .bold()
                .foregroundStyle(.white)
                .monospacedDigit()
        }
    }
}

struct ModuleCard: View {
    let title: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 15) {
            Image(systemName: icon)
                .font(.system(size: 30))
                .foregroundColor(color)
                .padding(15)
                .background(color.opacity(0.2))
                .clipShape(Circle())
            
            Text(title)
                .font(.headline)
                .bold()
                .foregroundStyle(.white)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(.ultraThinMaterial)
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.3), radius: 5)
    }
}

extension Double {
    func abbreviated() -> String {
        let num = abs(self)
        let sign = (self < 0) ? "-" : ""

        switch num {
        case 1_000_000_000...:
            let formatted = num / 1_000_000_000
            let string = String(format: "%.1f", formatted)
            return "\(sign)\(string.replacingOccurrences(of: ".0", with: ""))B"
            
        case 1_000_000...:
            let formatted = num / 1_000_000
            let string = String(format: "%.1f", formatted)
            return "\(sign)\(string.replacingOccurrences(of: ".0", with: ""))M"
            
        case 1_000...:
            let formatted = num / 1_000
            let string = String(format: "%.1f", formatted)
            return "\(sign)\(string.replacingOccurrences(of: ".0", with: ""))k"
            
        default:
            return "\(sign)\(String(format: "%.0f", num))"
        }
    }
}

extension Color {
    static let gold = Color(red: 1.0, green: 0.84, blue: 0.0)
    
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
