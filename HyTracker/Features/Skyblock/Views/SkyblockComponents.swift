//
//  SkyblockComponents.swift
//  HyTracker
//
//  Created by Arnaud on 26/11/2025.
//

import Foundation
import SwiftUI

// --- 1. PROFIL HEADER ---

struct ProfileHeaderView: View {
    
    let profileName: String
    let sbLevelXP: Double
    let fairySouls: Int
    let purse: Double
    let skillAvg: Double
    var joinedDate: Double?
    
    let onInfoTap: () -> Void
    
    var sbLevel: Int { Int(sbLevelXP / 100) }
    var sbProgress: Double { (sbLevelXP.truncatingRemainder(dividingBy: 100)) / 100 }
    
    var formattedDate: String {
        guard let timestamp = joinedDate else { return "N/A" }
        let date = Date(timeIntervalSince1970: timestamp / 1000)
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    var body: some View {
        HStack(alignment: .center, spacing: 15) {
            
            // World Icon
            Image("skyblock_head_globe")
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .background(Color("mc_dark_purple").opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            
            VStack(alignment: .leading, spacing: 5) {
                // Line 1 : Name + Bank + Info
                HStack {
                    Text(profileName)
                        .font(.title3)
                        .bold()
                        .foregroundStyle(Color("mc_primary"))
                    
                    Spacer()
                    
                    HStack(spacing: 4) {
                        Image(systemName: "bitcoinsign.circle.fill").foregroundStyle(Color("mc_gold"))
                        Text(purse.abbreviated()).bold().foregroundStyle(Color("mc_primary"))
                    }
                    .font(.caption)
                    .padding(6)
                    .background(Color("mc_gold").opacity(0.15))
                    .cornerRadius(8)
                    
                    Button(action: onInfoTap) {
                        Image(systemName: "info.circle.fill")
                            .font(.title3)
                            .foregroundStyle(.blue)
                    }
                    .padding(.leading, 5)
                }
                
                // Line 2 : Level bar
                HStack(spacing: 5) {
                    Text("Lvl \(sbLevel)")
                        .font(.caption)
                        .bold()
                        .foregroundStyle(.pink)
                    
                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            Capsule().fill(Color("mc_gray").opacity(0.2))
                            Capsule().fill(Color("mc_red")).frame(width: geo.size.width * sbProgress)
                        }
                    }
                    .frame(height: 6)
                }
                
                // Line 3 : Details
                HStack(spacing: 15) {
                    Label("\(fairySouls) Souls", systemImage: "sparkles")
                    Label("SA: \(String(format: "%.1f", skillAvg))", systemImage: "chart.bar")
                    Label(formattedDate, systemImage: "calendar")
                }
                .font(.caption2)
                .foregroundStyle(.secondary)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
            }
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(16)
        .shadow(color: Color("mc_black").opacity(0.05), radius: 10, x: 0, y: 5)
    }
}

// --- 2. UNIVERSAL ROW (SKILLS & COLLECTIONS) ---

struct SkyblockProgressRow: View {
    
    let title: String
    let color: Color
    
    // TODO: Custom Images
    var asset: String? = nil
    
    let levelText: String
    let progress: Double
    let progressTextLeft: String
    let progressTextRight: String
    
    @State private var isAnimating: Bool = false
    
    var isMaxed: Bool {
        return progress >= 1.0
    }
    
    var body: some View {
        HStack(spacing: 12) {
            
            Group {
                if let webID = asset?.lowercased(), !webID.isEmpty {
                    // Option 1 : Web Image (SkyCrypt)
                    ItemImageView(itemID: webID)
                        .frame(width: 32, height: 32)
                } else {
                    // Option 2 : SF Symbol (Apple)
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.title3)
                        .frame(width: 32, height: 32)
                }
            }
            .shadow(color: isMaxed ? Color("mc_gold").opacity(0.5) : color.opacity(0.4), radius: 2, x: 0, y: 2)
            
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(title)
                        .font(.subheadline)
                        .bold()
                        .foregroundStyle(Color("mc_primary"))
                    Spacer()
                    Text(levelText)
                        .font(.subheadline)
                        .bold()
                        .foregroundStyle(isMaxed ? Color("mc_gold") : color)
                }
                
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Capsule().fill(Color("mc_gray").opacity(0.2))
                        
                        if isMaxed {
                            Capsule()
                                .fill(
                                    LinearGradient(
                                        colors: [Color("mc_gold"), Color("mc_yellow"), Color("mc_gold")],
                                        startPoint: isAnimating ? .topLeading : .bottomLeading,
                                        endPoint: isAnimating ? .bottomTrailing : .topTrailing
                                    )
                                )
                                .frame(width: geo.size.width)
                                .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: isAnimating)
                        } else {
                            Capsule()
                                .fill(LinearGradient(colors: [color, color.opacity(0.7)], startPoint: .leading, endPoint: .trailing))
                                .frame(width: geo.size.width * min(max(progress, 0), 1))
                        }
                    }
                }
                .frame(height: 6)
                
                HStack {
                    Text(progressTextLeft)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                    Spacer()
                    ZStack {
                        Text(progressTextRight)
                            .font(.caption2).bold()
                            .foregroundStyle(isMaxed ? Color("mc_gold") : color)
                            .scaleEffect(isMaxed && isAnimating ? 1.1 : 1.0)
                            .animation(.easeInOut(duration: 1).repeatForever(autoreverses: true), value: isAnimating)
                        
                        if isMaxed {
                            SparkleView(delay: 0.0, x: -20, y: -5, isAnimating: isAnimating)
                            SparkleView(delay: 0.5, x: 25, y: 5, isAnimating: isAnimating)
                            SparkleView(delay: 1.0, x: 0, y: -15, isAnimating: isAnimating)
                        }
                    }
                }
            }
        }
        .padding(12)
        .background(
            LinearGradient(
                colors: isMaxed
                ? [color.opacity(0.15), Color("mc_gold").opacity(0.05)]
                : [color.opacity(0.15), color.opacity(0.02)],
                startPoint: .leading,
                endPoint: .center
            )
        )
        .cornerRadius(12)
        .onAppear {
            if isMaxed {
                isAnimating = true
            }
        }
    }
}

struct SparkleView: View {
    let delay: Double
    let x: CGFloat
    let y: CGFloat
    let isAnimating: Bool
    
    var body: some View {
        Image(systemName: "sparkle")
            .font(.system(size: 8))
            .foregroundStyle(Color("mc_yellow"))
            .offset(x: x, y: y)
            .opacity(isAnimating ? 1 : 0)
            .scaleEffect(isAnimating ? 1.2 : 0.5)
            .animation(
                .easeInOut(duration: 0.8)
                .repeatForever(autoreverses: true)
                .delay(delay),
                value: isAnimating
            )
    }
}

// --- 3. STATS BOX ---

struct StatBoxView: View {
    let icon: SBIcon
    let name: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 5) {
            HStack(spacing: 5) {
                icon.view(size: 14, color: color)
                
                Text(name)
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(color)
            }
            
            Text(value)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(Color("mc_primary"))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(color.opacity(0.2), lineWidth: 1)
        )
    }
}

// --- 4. STATS SECTION ---

struct StatSectionView<Content: View>: View {
    let title: String
    let icon: String
    let color: Color
    
    var columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    @ViewBuilder let content: Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 5) {
                Image(systemName: icon)
                Text(title.uppercased())
            }
            .font(.caption)
            .fontWeight(.bold)
            .foregroundStyle(color.opacity(0.8))
            .padding(.leading, 5)
            
            LazyVGrid(columns: columns, spacing: 10) {
                content
            }
        }
        .padding(.bottom, 15)
    }
}

// --- 5. ARMOR & EQUIPMENT ---

struct EquipmentView: View {
    
    let armor: [SkyblockItem]
    let equipment: [SkyblockItem]
    
    var body: some View {
        VStack(spacing: 12) {
            
            HStack(spacing: 15) {
                Spacer()
                ForEach(0..<4) { index in
                    if index < armor.count && !armor[index].isEmpty {
                        let item = armor[index]
                        ItemSlot(
                            iconName: item.iconName,
                            color: getRarityColor(item),
                            isFilled: true
                        )
                    } else {
                        ItemSlot(iconName: getEmptyArmorIcon(index: index), color: Color("mc_gray"), isFilled: false)
                    }
                }
                Spacer()
            }
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(16)
        .shadow(color: Color("mc_black").opacity(0.05), radius: 5, x: 0, y: 2)
    }
    
    func getEmptyArmorIcon(index: Int) -> String {
        let icons = ["empty_armor_helmet", "empty_armor_chestplate", "empty_armor_leggings", "empty_armor_boots"]
        return icons[index]
    }
    
    func getRarityColor(_ item: SkyblockItem) -> Color {
        if item.rawName.contains("§6") { return Color("mc_gold") }
        if item.rawName.contains("§d") { return Color("mc_light_purple") }
        if item.rawName.contains("§5") { return Color("mc_dark_purple") }
        if item.rawName.contains("§9") { return Color("mc_blue") }
        if item.rawName.contains("§a") { return Color("mc_green") }
        if item.rawName.contains("§f") { return Color("mc_white") }
        if item.rawName.contains("§7") { return Color("mc_gray") }
        return .gray
    }
}

struct ItemSlot: View {
    let iconName: String
    let color: Color
    let isFilled: Bool
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color("mc_dark_aqua").opacity(0.3))
                .frame(width: 50, height: 50)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(color, lineWidth: isFilled ? 2 : 1)
                )
            
            Image(iconName)
                .resizable()
                .interpolation(.none)
                .scaledToFit()
                .frame(width: 32, height: 32)
                .opacity(isFilled ? 1.0 : 0.4)
        }
    }
}
